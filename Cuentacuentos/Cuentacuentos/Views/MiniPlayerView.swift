import SwiftUI

struct MiniPlayerView: View {
    @ObservedObject var playerManager = PlayerManager.shared
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button {
            if playerManager.currentStory != nil {
                HapticManager.impact(style: .light)
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    playerManager.showFullPlayer = true
                }
            }
        } label: {
            HStack(spacing: 12) {
                // Story cover/icon
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(themeManager.current.accentGradient)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "book.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                // Story info
                if let story = playerManager.currentStory {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(story.title)
                            .font(AppTheme.roundedFont(.subheadline, weight: .semibold))
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        
                        Text(story.name)
                            .font(AppTheme.roundedFont(.caption))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                } else {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("No story selected")
                            .font(AppTheme.roundedFont(.subheadline, weight: .semibold))
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                        
                        Text("Tap to select a story")
                            .font(AppTheme.roundedFont(.caption))
                            .foregroundColor(.secondary.opacity(0.7))
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                // Play/Pause button
                if playerManager.currentStory != nil {
                    Button {
                        HapticManager.impact(style: .light)
                        if playerManager.isPlaying {
                            playerManager.pause()
                        } else if playerManager.isPaused {
                            playerManager.resume()
                        } else if let story = playerManager.currentStory {
                            playerManager.play(story: story)
                        }
                    } label: {
                        Image(systemName: playerManager.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.primary)
                            .frame(width: 44, height: 44)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Material.ultraThinMaterial
            )
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: -2)
        }
        .buttonStyle(.plain)
        .disabled(playerManager.currentStory == nil)
    }
}

#Preview {
    MiniPlayerView()
        .environmentObject(ThemeManager())
}

