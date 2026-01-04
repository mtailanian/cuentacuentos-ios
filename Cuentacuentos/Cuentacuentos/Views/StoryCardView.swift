import SwiftUI

struct StoryCardView: View {
    let story: Story
    let onSelect: () -> Void
    let onDelete: () -> Void
    @StateObject private var localizationManager = LocalizationManager.shared
    
    private var formattedDate: String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: story.createdAt) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .short
            return displayFormatter.string(from: date)
        }
        return story.createdAt
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text("saved.label".localized)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                    .textCase(.uppercase)
                    .tracking(0.5)
                
                Text(story.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                Text("\("story.for".localized) \(story.name) · \("story.age".localized) \(story.age) · \(story.language.displayName)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if let voice = story.voice {
                    Text("\("saved.voice".localized) \(voice == .auto ? "saved.auto".localized : voice.rawValue.capitalized)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text(formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(spacing: 8) {
                Button(action: onSelect) {
                    Text("saved.read".localized)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent)
                
                Button(action: onDelete) {
                    Text("saved.delete".localized)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.bordered)
                .tint(.red)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

#Preview {
    StoryCardView(
        story: Story(
            id: "1",
            title: "The Magic Forest",
            content: "Story content here...",
            createdAt: ISO8601DateFormatter().string(from: Date()),
            name: "Sofia",
            age: 6,
            language: .spanish,
            voice: nil,
            randomTopic: false,
            brief: nil
        ),
        onSelect: {},
        onDelete: {}
    )
    .padding()
}

