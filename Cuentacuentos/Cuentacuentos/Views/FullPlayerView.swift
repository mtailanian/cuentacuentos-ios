import SwiftUI

struct FullPlayerView: View {
    @ObservedObject var playerManager = PlayerManager.shared
    @EnvironmentObject var themeManager: ThemeManager
    @State private var playbackVoice: Story.Voice = .auto
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false
    
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
                                        .frame(width: min(geometry.size.width - 80, 320), height: min(geometry.size.width - 80, 320))
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
                                    
                                    Text("\("story.for".localized) \(story.name)")
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
                                        Text(formatTime(playerManager.currentTime))
                                            .font(AppTheme.roundedFont(.caption, weight: .medium))
                                            .foregroundColor(.secondary)
                                        
                                        Spacer()
                                        
                                        Text(formatTime(playerManager.duration))
                                            .font(AppTheme.roundedFont(.caption, weight: .medium))
                                            .foregroundColor(.secondary)
                                    }
                                }
                                .padding(.horizontal, 32)
                                
                                // Playback controls
                                HStack(spacing: 32) {
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
                                    
                                    // Play/Pause
                                    Button {
                                        HapticManager.impact(style: .medium)
                                        if playerManager.isPlaying {
                                            playerManager.pause()
                                        } else if playerManager.isPaused {
                                            playerManager.resume()
                                        } else {
                                            playerManager.play(story: story, voice: playbackVoice)
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
                                }
                                .padding(.vertical, 16)
                                
                                // Voice selector
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("story.playback.voice".localized)
                                        .font(AppTheme.roundedFont(.headline, weight: .semibold))
                                    
                                    Picker("", selection: $playbackVoice) {
                                        ForEach(Story.Voice.allCases, id: \.self) { voice in
                                            Text(voice.displayName).tag(voice)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .onChange(of: playbackVoice) { newVoice in
                                        if playerManager.isPlaying || playerManager.isPaused {
                                            playerManager.stop()
                                            playerManager.play(story: story, voice: newVoice == .auto ? nil : newVoice)
                                        }
                                    }
                                }
                                .padding(.horizontal, 32)
                                .padding(.top, 16)
                                
                                Spacer(minLength: 40)
                            }
                        }
                    }
                }
                .offset(y: dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.height > 0 {
                                isDragging = true
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
                                isDragging = false
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
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

#Preview {
    FullPlayerView()
        .environmentObject(ThemeManager())
}

