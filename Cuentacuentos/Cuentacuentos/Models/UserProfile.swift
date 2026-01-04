import Foundation

struct UserProfile: Codable {
    var name: String
    var avatarData: Data?
    var defaultAge: Int
    
    init(name: String = "Alex", avatarData: Data? = nil, defaultAge: Int = 6) {
        self.name = name
        self.avatarData = avatarData
        self.defaultAge = defaultAge
    }
    
    enum CodingKeys: String, CodingKey {
        case name, avatarData, defaultAge
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        avatarData = try container.decodeIfPresent(Data.self, forKey: .avatarData)
        // Handle backward compatibility: if defaultAge is missing, default to 6
        defaultAge = try container.decodeIfPresent(Int.self, forKey: .defaultAge) ?? 6
    }
}

