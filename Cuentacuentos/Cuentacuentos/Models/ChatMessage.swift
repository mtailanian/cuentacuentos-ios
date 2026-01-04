import Foundation

struct ChatMessage: Identifiable, Codable {
    let id: String
    let role: MessageRole
    let content: String
    let timestamp: Date
    var story: Story?
    
    enum MessageRole: String, Codable {
        case user
        case assistant
    }
    
    init(id: String = UUID().uuidString, role: MessageRole, content: String, timestamp: Date = Date(), story: Story? = nil) {
        self.id = id
        self.role = role
        self.content = content
        self.timestamp = timestamp
        self.story = story
    }
}

