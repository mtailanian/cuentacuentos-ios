import SwiftUI

struct ChatBubbleView: View {
    let message: ChatMessage
    let onSave: (() -> Void)?
    let onShare: (() -> Void)?
    let onToggleFavorite: (() -> Void)?
    let onQuickAction: ((String) -> Void)? // New callback for quick actions
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
                ProfileAvatar(image: profileAvatarImage, size: 32)
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
                
                Text(story.formattedMetadata)
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
                    FavoriteButton(
                        isFavorite: story.isFavorite,
                        onToggle: onToggleFavorite,
                        size: 36,
                        iconSize: 16
                    )
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
            
            // Quick action chips (only show for assistant messages with stories)
            if message.role == .assistant, message.story != nil, let onQuickAction = onQuickAction {
                quickActionChips(onAction: onQuickAction)
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    @ViewBuilder
    private func quickActionChips(onAction: @escaping (String) -> Void) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                QuickActionChip(
                    text: "chat.quickaction.longer".localized,
                    icon: "arrow.up.circle.fill",
                    onTap: { onAction("chat.quickaction.longer".localized) }
                )
                QuickActionChip(
                    text: "chat.quickaction.ending".localized,
                    icon: "arrow.triangle.2.circlepath",
                    onTap: { onAction("chat.quickaction.ending".localized) }
                )
                QuickActionChip(
                    text: "chat.quickaction.characters".localized,
                    icon: "person.2.fill",
                    onTap: { onAction("chat.quickaction.characters".localized) }
                )
            }
            .padding(.horizontal, 4)
        }
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
            onToggleFavorite: nil,
            onQuickAction: nil
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
            onToggleFavorite: {},
            onQuickAction: { _ in }
        )
    }
    .environmentObject(ThemeManager())
    .padding()
}

