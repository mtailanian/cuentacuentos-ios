import SwiftUI

struct FullPlayerView: View {
    @ObservedObject var playerManager = PlayerManager.shared
    @EnvironmentObject var themeManager: ThemeManager
    @State private var playbackVoice: Story.Voice = .auto
    @State private var dragOffset: CGFloat = 0
    @State private var showVoiceMenu = false
    @State private var showSpeedMenu = false
    
    private let playbackSpeeds: [Double] = [0.6, 0.7, 0.8, 0.9, 1.0, 1.25, 1.5]
    
    private func speedLabel(for rate: Double) -> String {
        if rate == 1.0 {
            return "x1"
        } else if rate < 1.0 {
            return String(format: "x%.1f", rate)
        } else {
            return String(format: "x%.2f", rate)
        }
    }
    
    var body: some View {
        if let story = playerManager.currentStory {
            GeometryReader { geometry in
                ZStack {
                    // Background with theme gradient
                    themeManager.current.background
                        .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        // Drag indicator and close button
                        HStack {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.secondary.opacity(0.5))
                                .frame(width: 40, height: 5)
                            
                            Spacer()
                            
                            Button {
                                HapticManager.impact(style: .light)
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    playerManager.showFullPlayer = false
                                }
                            } label: {
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.primary)
                                    .frame(width: 44, height: 44)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .padding(.bottom, 20)
                        
                        ScrollView {
                            VStack(spacing: 32) {
                                // Story cover/art
                                ZStack {
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(themeManager.current.accentGradient)
                                        .frame(width: max(min(geometry.size.width - 80, 320), 200), height: max(min(geometry.size.width - 80, 320), 200))
                                        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                                    
                                    Image(systemName: "book.fill")
                                        .font(.system(size: 80, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.9))
                                }
                                .padding(.top, 20)
                                
                                // Story info
                                VStack(spacing: 8) {
                                    Text(story.title)
                                        .font(AppTheme.roundedFont(.title, weight: .bold))
                                        .foregroundColor(.primary)
                                        .multilineTextAlignment(.center)
                                    
                                    Text(story.formattedMetadataShort)
                                        .font(AppTheme.roundedFont(.subheadline))
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal, 32)
                                
                                // Progress slider
                                VStack(spacing: 8) {
                                    Slider(
                                        value: Binding(
                                            get: { playerManager.currentTime },
                                            set: { newValue in
                                                playerManager.seek(to: newValue)
                                            }
                                        ),
                                        in: 0...max(playerManager.duration, 1)
                                    )
                                    .tint(themeManager.current.accentColor)
                                    
                                    HStack {
                                        Text(playerManager.currentTime.formattedTime())
                                            .font(AppTheme.roundedFont(.caption, weight: .medium))
                                            .foregroundColor(.secondary)
                                        
                                        Spacer()
                                        
                                        Text(playerManager.duration.formattedTime())
                                            .font(AppTheme.roundedFont(.caption, weight: .medium))
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.horizontal, 32)
                                
                                // Playback controls
                                HStack(spacing: 0) {
                                    // Voice selector icon (left of previous)
                                    Menu {
                                        ForEach(Story.Voice.allCases, id: \.self) { voice in
                                            Button {
                                                playbackVoice = voice
                                                if playerManager.isPlaying || playerManager.isPaused {
                                                    playerManager.stop()
                                                    playerManager.play(story: story, voice: voice == .auto ? nil : voice)
                                                }
                                            } label: {
                                                HStack {
                                                    Text(voice.displayName)
                                                    if playbackVoice == voice {
                                                        Image(systemName: "checkmark")
                                                    }
                                                }
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "person.wave.2.fill")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundColor(.secondary)
                                            .frame(width: 44, height: 44)
                                    }
                                    
                                    Spacer()
                                    
                                    // Previous (disabled for now)
                                    Button {
                                        // TODO: Previous story
                                    } label: {
                                        Image(systemName: "backward.fill")
                                            .font(.system(size: 24, weight: .semibold))
                                            .foregroundColor(.secondary)
                                            .frame(width: 44, height: 44)
                                    }
                                    .disabled(true)
                                    
                                    Spacer()
                                        .frame(width: 24)
                                    
                                    // Play/Pause
                                    Button {
                                        HapticManager.impact(style: .medium)
                                        if playerManager.isPlaying {
                                            playerManager.pause()
                                        } else if playerManager.isPaused {
                                            playerManager.resume()
                                        } else {
                                            playerManager.play(story: story, voice: playbackVoice == .auto ? nil : playbackVoice)
                                        }
                                    } label: {
                                        ZStack {
                                            Circle()
                                                .fill(themeManager.current.accentGradient)
                                                .frame(width: 70, height: 70)
                                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                                            
                                            if playerManager.isLoading {
                                                ProgressView()
                                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            } else {
                                                Image(systemName: playerManager.isPlaying ? "pause.fill" : "play.fill")
                                                    .font(.system(size: 32, weight: .bold))
                                                    .foregroundColor(.white)
                                            }
                                        }
                                    }
                                    .buttonStyle(.plain)
                                    
                                    Spacer()
                                        .frame(width: 24)
                                    
                                    // Next (disabled for now)
                                    Button {
                                        // TODO: Next story
                                    } label: {
                                        Image(systemName: "forward.fill")
                                            .font(.system(size: 24, weight: .semibold))
                                            .foregroundColor(.secondary)
                                            .frame(width: 44, height: 44)
                                    }
                                    .disabled(true)
                                    
                                    Spacer()
                                    
                                    // Speed selector icon (right of next)
                                    Menu {
                                        ForEach(playbackSpeeds, id: \.self) { speed in
                                            Button {
                                                playerManager.setPlaybackRate(speed)
                                            } label: {
                                                HStack {
                                                    Text(speedLabel(for: speed))
                                                    if abs(playerManager.playbackRate - speed) < 0.01 {
                                                        Image(systemName: "checkmark")
                                                    }
                                                }
                                            }
                                        }
                                    } label: {
                                        Text(speedLabel(for: playerManager.playbackRate))
                                            .font(AppTheme.roundedFont(.subheadline, weight: .semibold))
                                            .foregroundColor(.secondary)
                                            .frame(width: 44, height: 44)
                                    }
                                }
                                .padding(.horizontal, 32)
                                .padding(.vertical, 16)
                                
                                // Story text (like Spotify lyrics)
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("story.text".localized)
                                        .font(AppTheme.roundedFont(.headline, weight: .semibold))
                                        .foregroundColor(.primary)
                                    
                                    ScrollView {
                                        VStack(alignment: .leading, spacing: 18) {
                                            ForEach(story.content.components(separatedBy: "\n").filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }, id: \.self) { paragraph in
                                                Text(paragraph.trimmingCharacters(in: .whitespaces))
                                                    .font(AppTheme.roundedFont(.body))
                                                    .foregroundColor(.primary.opacity(0.9))
                                                    .lineSpacing(10)
                                                    .fixedSize(horizontal: false, vertical: true)
                                            }
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.horizontal, 4)
                                    }
                                    .frame(maxHeight: max(geometry.size.height * 0.45, 250))
                                }
                                .padding(.horizontal, 32)
                                .padding(.top, 24)
                                .padding(.bottom, 40)
                                
                                Spacer(minLength: 20)
                            }
                        }
                    }
                }
                .offset(y: dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.height > 0 {
                                dragOffset = value.translation.height
                            }
                        }
                        .onEnded { value in
                            if value.translation.height > 150 {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    playerManager.showFullPlayer = false
                                }
                            }
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                dragOffset = 0
                            }
                        }
                )
            }
                .transition(.move(edge: .bottom))
                .onAppear {
                    playbackVoice = story.voice ?? .auto
                }
        }
    }
    
}

#Preview {
    FullPlayerView()
        .environmentObject(ThemeManager())
}

