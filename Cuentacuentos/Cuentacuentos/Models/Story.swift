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

