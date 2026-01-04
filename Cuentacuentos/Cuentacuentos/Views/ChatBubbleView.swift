import SwiftUI

struct ChatBubbleView: View {
    let message: ChatMessage
    let onSave: (() -> Void)?
    let onShare: (() -> Void)?
    let onToggleFavorite: (() -> Void)?
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject private var playerManager = PlayerManager.shared
    
    private let storageService = StorageService()
    @State private var profileAvatarImage: UIImage?
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if message.role == .assistant {
                // Assistant avatar
                ZStack {
                    Circle()
                        .fill(themeManager.current.accentGradient)
                        .frame(width: 32, height: 32)
                    Image(systemName: "sparkles")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            
            VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 8) {
                // Message content
                Text(message.content)
                    .font(AppTheme.roundedFont(.body))
                    .foregroundColor(message.role == .user ? .white : .primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        message.role == .user
                            ? AnyShapeStyle(themeManager.current.accentGradient)
                            : AnyShapeStyle(Color(.systemGray6))
                    )
                    .cornerRadius(20, corners: message.role == .user ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight])
                
                // Story display if available
                if let story = message.story {
                    storyCard(for: story)
                }
            }
            
            if message.role == .user {
                // User avatar
                ZStack {
                    if let image = profileAvatarImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 32, height: 32)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color(.systemGray4))
                            .frame(width: 32, height: 32)
                        Image(systemName: "person.fill")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: message.role == .user ? .trailing : .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .onAppear {
            if message.role == .user {
                loadProfileAvatar()
            }
        }
    }
    
    private func loadProfileAvatar() {
        if let profile = storageService.loadProfile(),
           let avatarData = profile.avatarData {
            profileAvatarImage = UIImage(data: avatarData)
        }
    }
    
    @ViewBuilder
    private func storyCard(for story: Story) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Story title and metadata
            VStack(alignment: .leading, spacing: 4) {
                Text(story.title)
                    .font(AppTheme.roundedFont(.headline, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("\("story.for".localized) \(story.name) · \("story.age".localized) \(story.age) · \(story.language.displayName)")
                    .font(AppTheme.roundedFont(.caption))
                    .foregroundColor(.secondary)
            }
            
            // Story content preview
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(story.content.components(separatedBy: "\n").filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.prefix(3), id: \.self) { paragraph in
                        Text(paragraph.trimmingCharacters(in: .whitespaces))
                            .font(AppTheme.roundedFont(.subheadline))
                            .foregroundColor(.primary)
                            .lineSpacing(4)
                    }
                }
            }
            .frame(maxHeight: 150)
            
            // Action buttons
            HStack(spacing: 12) {
                // Play button (icon only)
                Button {
                    HapticManager.impact(style: .medium)
                    if playerManager.isPlaying && playerManager.currentStory?.id == story.id {
                        playerManager.pause()
                    } else if playerManager.isPaused && playerManager.currentStory?.id == story.id {
                        playerManager.resume()
                    } else {
                        playerManager.play(story: story, voice: story.voice)
                    }
                } label: {
                    if playerManager.isLoading && playerManager.currentStory?.id == story.id {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                            .frame(width: 36, height: 36)
                    } else {
                        Image(systemName: playerManager.isPlaying && playerManager.currentStory?.id == story.id ? "pause.fill" : "play.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                    }
                }
                .background(themeManager.current.accentGradient)
                .cornerRadius(18)
                .buttonStyle(.plain)
                .disabled(playerManager.isLoading && playerManager.currentStory?.id == story.id)
                
                if let onToggleFavorite = onToggleFavorite {
                    Button {
                        HapticManager.notification(type: story.isFavorite ? .warning : .success)
                        onToggleFavorite()
                    } label: {
                        Image(systemName: story.isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(story.isFavorite ? .red : .secondary)
                            .frame(width: 36, height: 36)
                            .background(story.isFavorite ? Color.red.opacity(0.1) : Color(.systemGray6))
                            .cornerRadius(18)
                    }
                    .buttonStyle(.plain)
                }
                
                if let onShare = onShare {
                    Button {
                        HapticManager.impact(style: .light)
                        onShare()
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.secondary)
                            .frame(width: 36, height: 36)
                            .background(Color(.systemGray6))
                            .cornerRadius(18)
                    }
                    .buttonStyle(.plain)
                }
                
                if let onSave = onSave {
                    Button {
                        HapticManager.notification(type: .success)
                        onSave()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "bookmark.fill")
                                .font(.system(size: 14, weight: .semibold))
                            Text("story.save".localized)
                                .font(AppTheme.roundedFont(.caption, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(themeManager.current.accentGradient)
                        .cornerRadius(20)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    VStack {
        ChatBubbleView(
            message: ChatMessage(role: .user, content: "Create a story about a brave knight"),
            onSave: nil,
            onShare: nil,
            onToggleFavorite: nil
        )
        
        ChatBubbleView(
            message: ChatMessage(
                role: .assistant,
                content: "Here's your story!",
                story: Story(
                    id: "1",
                    title: "The Brave Knight",
                    content: "Once upon a time...",
                    createdAt: ISO8601DateFormatter().string(from: Date()),
                    name: "Sofia",
                    age: 6,
                    language: .spanish,
                    voice: nil,
                    randomTopic: false,
                    brief: nil
                )
            ),
            onSave: {},
            onShare: {},
            onToggleFavorite: {}
        )
    }
    .environmentObject(ThemeManager())
    .padding()
}

