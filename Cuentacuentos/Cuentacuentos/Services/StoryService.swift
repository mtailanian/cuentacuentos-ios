import Foundation
import Combine

class StoryService: ObservableObject {
    private let apiKey: String
    
    init() {
        // Get API key from environment or Info.plist
        // In production, use a secure method to store API keys
        var foundKey = ""
        
        // Try environment variable first
        if let envKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"], !envKey.isEmpty {
            foundKey = envKey
        }
        // Try Info.plist
        else if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
                let plist = NSDictionary(contentsOfFile: path),
                let plistKey = plist["OPENAI_API_KEY"] as? String,
                !plistKey.isEmpty,
                plistKey != "YOUR_OPENAI_API_KEY_HERE" {
            foundKey = plistKey
        }
        
        self.apiKey = foundKey
        
        if foundKey.isEmpty {
            print("Warning: OPENAI_API_KEY not found. Story generation will fail.")
            print("Please set OPENAI_API_KEY in Info.plist or as an environment variable.")
        }
    }
    
    func generateStory(
        name: String,
        age: Int,
        brief: String?,
        randomTopic: Bool,
        length: StoryFormValues.StoryLength,
        language: Story.Language
    ) async throws -> StoryResponse {
        guard !apiKey.isEmpty else {
            throw StoryServiceError.missingAPIKey
        }
        
        let storyLengthMap: [StoryFormValues.StoryLength: (words: String, tokens: Int)] = [
            .short: ("exactly 250 words", 500),
            .medium: ("exactly 400 words", 800),
            .long: ("exactly 600 words", 1200)
        ]
        
        let lengthInfo = storyLengthMap[length] ?? ("exactly 250 words", 500)
        
        let languageLabelMap: [Story.Language: String] = [
            .english: "English",
            .spanish: "Spanish (neutral LATAM)",
            .french: "French",
            .german: "German",
            .italian: "Italian",
            .portuguese: "Portuguese",
            .japanese: "Japanese"
        ]
        
        let targetLanguage = languageLabelMap[language] ?? "Spanish (neutral LATAM)"
        let userPrompt = [
            "Child name: \(name)",
            "Child age: \(age)",
            randomTopic
                ? "Create a random, friendly topic suitable for the age."
                : "Story idea: \(brief ?? "A gentle, uplifting theme.")",
            "IMPORTANT: The story must be exactly \(lengthInfo.words). Do not make it shorter. The story content should be \(lengthInfo.words) long.",
            "Write the story in \(targetLanguage) with simple, age-appropriate language and a kind tone. If Spanish, use neutral Latin American Spanish.",
            "Return JSON with fields: title (string), story (string). The story field must contain a complete story that is \(lengthInfo.words) in length."
        ].joined(separator: "\n")
        
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "model": "gpt-4o-mini",
            "temperature": 0.8,
            "max_tokens": lengthInfo.tokens,
            "response_format": ["type": "json_object"] as [String: Any],
            "messages": [
                [
                    "role": "system",
                    "content": "You write warm, positive, age-appropriate children's stories with simple language and clear morals. Match the requested language exactly and keep it friendly for kids. Always write stories that match the exact word count requested - do not make them shorter."
                ] as [String: Any],
                [
                    "role": "user",
                    "content": userPrompt
                ] as [String: Any]
            ] as [[String: Any]]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw StoryServiceError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let errorData = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let error = errorData["error"] as? [String: Any],
               let message = error["message"] as? String {
                throw StoryServiceError.apiError(message)
            }
            throw StoryServiceError.httpError(httpResponse.statusCode)
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let choices = json["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String,
              let contentData = content.data(using: .utf8),
              let parsed = try? JSONSerialization.jsonObject(with: contentData) as? [String: Any],
              let story = parsed["story"] as? String else {
            throw StoryServiceError.invalidResponse
        }
        
        let title = parsed["title"] as? String ?? "Your Story"
        
        return StoryResponse(title: title, story: story)
    }
    
    func generateTTS(
        text: String,
        language: Story.Language,
        voice: Story.Voice?
    ) async throws -> Data {
        guard !apiKey.isEmpty else {
            throw StoryServiceError.missingAPIKey
        }
        
        let langToCode: [Story.Language: String] = [
            .english: "en",
            .spanish: "es",
            .french: "fr",
            .german: "de",
            .italian: "it",
            .portuguese: "pt",
            .japanese: "ja"
        ]
        
        let normalizedVoice = voice != nil && voice != .auto ? voice!.rawValue : nil
        let voiceForLang = normalizedVoice ?? (language == .english ? "alloy" : "verse")
        
        let url = URL(string: "https://api.openai.com/v1/audio/speech")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "model": "gpt-4o-mini-tts",
            "voice": voiceForLang,
            "input": text,
            "format": "mp3",
            "input_language": langToCode[language] ?? "en"
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw StoryServiceError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw StoryServiceError.httpError(httpResponse.statusCode)
        }
        
        return data
    }
}

enum StoryServiceError: LocalizedError {
    case missingAPIKey
    case invalidResponse
    case httpError(Int)
    case apiError(String)
    
    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            return "OpenAI API key is missing. Please configure it in your environment or Info.plist."
        case .invalidResponse:
            return "Invalid response from the server."
        case .httpError(let code):
            return "HTTP error: \(code)"
        case .apiError(let message):
            return message
        }
    }
}

