import Foundation

struct Story: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let content: String
    let createdAt: String
    let name: String
    let age: Int
    let language: Language
    var voice: Voice?
    let randomTopic: Bool
    var brief: String?
    var isFavorite: Bool
    
    init(id: String, title: String, content: String, createdAt: String, name: String, age: Int, language: Language, voice: Voice? = nil, randomTopic: Bool, brief: String? = nil, isFavorite: Bool = false) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.name = name
        self.age = age
        self.language = language
        self.voice = voice
        self.randomTopic = randomTopic
        self.brief = brief
        self.isFavorite = isFavorite
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, content, createdAt, name, age, language, voice, randomTopic, brief, isFavorite
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        content = try container.decode(String.self, forKey: .content)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        name = try container.decode(String.self, forKey: .name)
        age = try container.decode(Int.self, forKey: .age)
        language = try container.decode(Language.self, forKey: .language)
        voice = try container.decodeIfPresent(Voice.self, forKey: .voice)
        randomTopic = try container.decode(Bool.self, forKey: .randomTopic)
        brief = try container.decodeIfPresent(String.self, forKey: .brief)
        // Handle backward compatibility: if isFavorite is missing, default to false
        isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(content, forKey: .content)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(name, forKey: .name)
        try container.encode(age, forKey: .age)
        try container.encode(language, forKey: .language)
        try container.encodeIfPresent(voice, forKey: .voice)
        try container.encode(randomTopic, forKey: .randomTopic)
        try container.encodeIfPresent(brief, forKey: .brief)
        try container.encode(isFavorite, forKey: .isFavorite)
    }
    
    enum Language: String, Codable, CaseIterable {
        case spanish = "spanish"
        case english = "english"
        case french = "french"
        case german = "german"
        case italian = "italian"
        case portuguese = "portuguese"
        case japanese = "japanese"
        
        var displayName: String {
            let key: String
            switch self {
            case .spanish: key = "language.spanish"
            case .english: key = "language.english"
            case .french: key = "language.french"
            case .german: key = "language.german"
            case .italian: key = "language.italian"
            case .portuguese: key = "language.portuguese"
            case .japanese: key = "language.japanese"
            }
            return LocalizationManager.shared.localizedString(key)
        }
    }
    
    enum Voice: String, Codable, CaseIterable {
        case auto = "auto"
        case alloy = "alloy"
        case ash = "ash"
        case ballad = "ballad"
        case coral = "coral"
        case echo = "echo"
        case fable = "fable"
        case nova = "nova"
        case onyx = "onyx"
        case sage = "sage"
        case shimmer = "shimmer"
        case verse = "verse"
        case marin = "marin"
        case cedar = "cedar"
        
        var displayName: String {
            if self == .auto {
                return LocalizationManager.shared.localizedString("saved.auto")
            }
            return rawValue.capitalized
        }
    }
}

struct StoryFormValues {
    var name: String = ""
    var age: String = ""
    var brief: String = ""
    var randomTopic: Bool = false
    var length: StoryLength = .short
    
    enum StoryLength: String, CaseIterable {
        case short = "short"
        case medium = "medium"
        case long = "long"
        
        var displayName: String {
            let key: String
            switch self {
            case .short: key = "length.short"
            case .medium: key = "length.medium"
            case .long: key = "length.long"
            }
            return LocalizationManager.shared.localizedString(key)
        }
    }
}

struct StoryResponse: Codable {
    let title: String
    let story: String
}

