import Foundation

class StorageService {
    private let storageKey = "cuentacuentos-stories"
    private let profileKey = "cuentacuentos-profile"
    private let lastPlayedStoryKey = "cuentacuentos-last-played-story"
    private let chatMessagesKey = "cuentacuentos-chat-messages"
    
    func loadStories() -> [Story] {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            print("No stories data found in UserDefaults")
            return []
        }
        
        do {
            let stories = try JSONDecoder().decode([Story].self, from: data)
            print("Successfully loaded \(stories.count) stories from UserDefaults")
        return stories
        } catch {
            print("Error decoding stories: \(error)")
            return []
        }
    }
    
    func saveStories(_ stories: [Story]) {
        do {
            let data = try JSONEncoder().encode(stories)
        UserDefaults.standard.set(data, forKey: storageKey)
            UserDefaults.standard.synchronize() // Force immediate write
            print("Successfully saved \(stories.count) stories to UserDefaults")
        } catch {
            print("Error encoding stories: \(error)")
        }
    }
    
    func loadProfile() -> UserProfile? {
        guard let data = UserDefaults.standard.data(forKey: profileKey),
              let profile = try? JSONDecoder().decode(UserProfile.self, from: data) else {
            return nil
        }
        return profile
    }
    
    func saveProfile(_ profile: UserProfile) {
        guard let data = try? JSONEncoder().encode(profile) else {
            return
        }
        UserDefaults.standard.set(data, forKey: profileKey)
    }
    
    func saveLastPlayedStoryId(_ storyId: String?) {
        if let storyId = storyId {
            UserDefaults.standard.set(storyId, forKey: lastPlayedStoryKey)
        } else {
            UserDefaults.standard.removeObject(forKey: lastPlayedStoryKey)
        }
    }
    
    func loadLastPlayedStoryId() -> String? {
        return UserDefaults.standard.string(forKey: lastPlayedStoryKey)
    }
    
    func loadChatMessages() -> [ChatMessage] {
        guard let data = UserDefaults.standard.data(forKey: chatMessagesKey) else {
            print("No chat messages data found in UserDefaults")
            return []
        }
        
        do {
            let messages = try JSONDecoder().decode([ChatMessage].self, from: data)
            print("Successfully loaded \(messages.count) chat messages from UserDefaults")
            return messages
        } catch {
            print("Error decoding chat messages: \(error)")
            return []
        }
    }
    
    func saveChatMessages(_ messages: [ChatMessage]) {
        do {
            let data = try JSONEncoder().encode(messages)
            UserDefaults.standard.set(data, forKey: chatMessagesKey)
            UserDefaults.standard.synchronize() // Force immediate write
            print("Successfully saved \(messages.count) chat messages to UserDefaults")
        } catch {
            print("Error encoding chat messages: \(error)")
        }
    }
    
    // Audio caching methods
    private var audioCacheDirectory: URL {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioDir = documentsPath.appendingPathComponent("AudioCache", isDirectory: true)
        
        // Create directory if it doesn't exist
        if !FileManager.default.fileExists(atPath: audioDir.path) {
            try? FileManager.default.createDirectory(at: audioDir, withIntermediateDirectories: true)
        }
        
        return audioDir
    }
    
    func audioCacheKey(for storyId: String, voice: Story.Voice?) -> String {
        let voiceString = voice?.rawValue ?? "auto"
        return "\(storyId)_\(voiceString)"
    }
    
    func saveAudioData(_ audioData: Data, for storyId: String, voice: Story.Voice?) {
        let fileName = "\(audioCacheKey(for: storyId, voice: voice)).mp3"
        let fileURL = audioCacheDirectory.appendingPathComponent(fileName)
        
        do {
            try audioData.write(to: fileURL)
            print("Audio cached: \(fileName)")
        } catch {
            print("Error saving audio cache: \(error)")
        }
    }
    
    func loadAudioData(for storyId: String, voice: Story.Voice?) -> Data? {
        let fileName = "\(audioCacheKey(for: storyId, voice: voice)).mp3"
        let fileURL = audioCacheDirectory.appendingPathComponent(fileName)
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        do {
            let audioData = try Data(contentsOf: fileURL)
            print("Audio loaded from cache: \(fileName)")
            return audioData
        } catch {
            print("Error loading audio cache: \(error)")
            return nil
        }
    }
    
    func hasCachedAudio(for storyId: String, voice: Story.Voice?) -> Bool {
        let fileName = "\(audioCacheKey(for: storyId, voice: voice)).mp3"
        let fileURL = audioCacheDirectory.appendingPathComponent(fileName)
        return FileManager.default.fileExists(atPath: fileURL.path)
    }
    
    func clearAudioCache(for storyId: String? = nil) {
        if let storyId = storyId {
            // Clear audio for specific story (all voices)
            let files = try? FileManager.default.contentsOfDirectory(at: audioCacheDirectory, includingPropertiesForKeys: nil)
            files?.forEach { fileURL in
                if fileURL.lastPathComponent.hasPrefix("\(storyId)_") {
                    try? FileManager.default.removeItem(at: fileURL)
                }
            }
        } else {
            // Clear all audio cache
            try? FileManager.default.removeItem(at: audioCacheDirectory)
            try? FileManager.default.createDirectory(at: audioCacheDirectory, withIntermediateDirectories: true)
        }
    }
}

