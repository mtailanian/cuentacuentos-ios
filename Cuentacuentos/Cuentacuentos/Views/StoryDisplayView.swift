import SwiftUI

struct StoryDisplayView: View {
    let story: Story
    let onSave: (() -> Void)?
    let onShare: () -> Void
    let onToggleFavorite: (() -> Void)?
    @StateObject private var localizationManager = LocalizationManager.shared
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject private var playerManager = PlayerManager.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("story.your.story".localized)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .textCase(.uppercase)
                        .tracking(0.5)
                    
                    Text(story.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(story.formattedMetadata)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Action buttons - same style as chat card
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
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(story.content.components(separatedBy: "\n").filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }, id: \.self) { paragraph in
                        Text(paragraph.trimmingCharacters(in: .whitespaces))
                            .font(.body)
                            .lineSpacing(4)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    StoryDisplayView(
        story: Story(
            id: "1",
            title: "The Magic Forest",
            content: "Once upon a time, there was a little girl named Sofia who loved to explore.\n\nShe found a magical forest where all the animals could talk.",
            createdAt: ISO8601DateFormatter().string(from: Date()),
            name: "Sofia",
            age: 6,
            language: .spanish,
            voice: nil,
            randomTopic: false,
            brief: nil
        ),
        onSave: nil,
        onShare: {},
        onToggleFavorite: nil
    )
    .padding()
}

