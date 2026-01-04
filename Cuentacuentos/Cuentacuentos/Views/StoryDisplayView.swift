import SwiftUI

struct StoryDisplayView: View {
    let story: Story
    let onSave: () -> Void
    let onShare: () -> Void
    let onToggleFavorite: (() -> Void)?
    @StateObject private var localizationManager = LocalizationManager.shared
    @State private var playbackVoice: Story.Voice = .auto
    
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
                    
                    Text("\("story.for".localized) \(story.name) · \("story.age".localized) \(story.age) · \(story.language.displayName)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    // Favorite button
                    if let onToggleFavorite = onToggleFavorite {
                        Button(action: {
                            HapticManager.notification(type: story.isFavorite ? .warning : .success)
                            onToggleFavorite()
                        }) {
                            Image(systemName: story.isFavorite ? "heart.fill" : "heart")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(story.isFavorite ? .red : .secondary)
                                .frame(width: 44, height: 44)
                                .background(story.isFavorite ? Color.red.opacity(0.1) : Color(.systemGray6))
                                .cornerRadius(AppTheme.Radii.medium)
                        }
                        .buttonStyle(.plain)
                    }
                
                VStack(spacing: 8) {
                        Button(action: {
                            HapticManager.impact(style: .light)
                            onShare()
                        }) {
                        Text("story.share".localized)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.bordered)
                    
                        Button(action: {
                            HapticManager.notification(type: .success)
                            onSave()
                        }) {
                        Text("story.save".localized)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.borderedProminent)
                    }
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
            
            // Playback section inspired by Spotify-style player
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("story.playback.voice".localized)
                            .font(AppTheme.roundedFont(.subheadline, weight: .semibold))
                        Text("story.voice.hint".localized)
                            .font(AppTheme.roundedFont(.caption))
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Picker("", selection: $playbackVoice) {
                        ForEach(Story.Voice.allCases, id: \.self) { voice in
                            Text(voice.displayName).tag(voice)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Button {
                    HapticManager.impact(style: .medium)
                    PlayerManager.shared.play(story: story, voice: playbackVoice == .auto ? nil : playbackVoice)
                } label: {
                    HStack {
                        if PlayerManager.shared.isLoading && PlayerManager.shared.currentStory?.id == story.id {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Image(systemName: PlayerManager.shared.isPlaying && PlayerManager.shared.currentStory?.id == story.id ? "pause.fill" : "play.fill")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        Text(PlayerManager.shared.isLoading && PlayerManager.shared.currentStory?.id == story.id ? "audio.preparing".localized : PlayerManager.shared.isPlaying && PlayerManager.shared.currentStory?.id == story.id ? "audio.playing".localized : "audio.play".localized)
                            .font(AppTheme.roundedFont(.subheadline, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .foregroundColor(.white)
                    .background(
                        LinearGradient(
                            colors: [
                                AppTheme.Colors.primary,
                                AppTheme.Colors.secondary
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(AppTheme.Radii.medium)
                }
                .buttonStyle(.plain)
                .disabled(PlayerManager.shared.isLoading && PlayerManager.shared.currentStory?.id == story.id)
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [
                        AppTheme.Colors.primary.opacity(0.18),
                        AppTheme.Colors.secondary.opacity(0.16)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(AppTheme.Radii.large)
            .shadow(color: AppTheme.Colors.subtleShadow, radius: 6, x: 0, y: 3)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .onAppear {
            playbackVoice = story.voice ?? .auto
        }
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
        onSave: {},
        onShare: {},
        onToggleFavorite: nil
    )
    .padding()
}

