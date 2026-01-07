import Foundation

struct UserProfile: Codable {
    var name: String
    var avatarData: Data?
    var defaultAge: Int
    var defaultLength: StoryFormValues.StoryLength
    
    init(name: String = "Alex", avatarData: Data? = nil, defaultAge: Int = 6, defaultLength: StoryFormValues.StoryLength = .short) {
        self.name = name
        self.avatarData = avatarData
        self.defaultAge = defaultAge
        self.defaultLength = defaultLength
    }
    
    enum CodingKeys: String, CodingKey {
        case name, avatarData, defaultAge, defaultLength
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        avatarData = try container.decodeIfPresent(Data.self, forKey: .avatarData)
        // Handle backward compatibility: if defaultAge is missing, default to 6
        defaultAge = try container.decodeIfPresent(Int.self, forKey: .defaultAge) ?? 6
        // Handle backward compatibility: if defaultLength is missing, default to short
        if let lengthString = try? container.decodeIfPresent(String.self, forKey: .defaultLength),
           let length = StoryFormValues.StoryLength(rawValue: lengthString) {
            defaultLength = length
        } else {
            defaultLength = .short
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(avatarData, forKey: .avatarData)
        try container.encode(defaultAge, forKey: .defaultAge)
        try container.encode(defaultLength.rawValue, forKey: .defaultLength)
    }
}

