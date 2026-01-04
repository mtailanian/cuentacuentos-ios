import SwiftUI
import AVFoundation
import Combine

struct AudioPlayerView: View {
    let text: String
    let language: Story.Language
    let voice: Story.Voice?
    
    @StateObject private var player = AudioPlayerViewModel()
    @StateObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                Task {
                    await player.play(text: text, language: language, voice: voice)
                }
            }) {
                HStack {
                    if player.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                    }
                    Text(player.isLoading ? "audio.preparing".localized : player.isPlaying ? "audio.playing".localized : "audio.play".localized)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .disabled(player.isLoading)
            
            Button(action: {
                player.pause()
            }) {
                Text("audio.pause".localized)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.bordered)
            .disabled(!player.isPlaying && !player.isPaused)
            
            Button(action: {
                player.stop()
            }) {
                Text("audio.stop".localized)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.bordered)
            .disabled(!player.isPlaying && !player.isPaused)
        }
    }
}

class AudioPlayerViewModel: NSObject, ObservableObject {
    @Published var isPlaying = false
    @Published var isPaused = false
    @Published var isLoading = false
    
    private var audioPlayer: AVAudioPlayer?
    private var speechSynthesizer = AVSpeechSynthesizer()
    private let storyService = StoryService()
    
    override init() {
        super.init()
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
    }
    
    func play(text: String, language: Story.Language, voice: Story.Voice?) async {
        await MainActor.run {
            isLoading = true
            isPlaying = false
            isPaused = false
        }
        
        do {
            let audioData = try await storyService.generateTTS(
                text: text,
                language: language,
                voice: voice
            )
            
            await MainActor.run {
                do {
                    audioPlayer = try AVAudioPlayer(data: audioData)
                    audioPlayer?.delegate = self
                    audioPlayer?.prepareToPlay()
                    audioPlayer?.play()
                    isLoading = false
                    isPlaying = true
                    isPaused = false
                } catch {
                    print("Error playing audio: \(error)")
                    fallbackToSpeechSynthesis(text: text, language: language)
                }
            }
        } catch {
            print("Error generating TTS: \(error)")
            await MainActor.run {
                fallbackToSpeechSynthesis(text: text, language: language)
            }
        }
    }
    
    private func fallbackToSpeechSynthesis(text: String, language: Story.Language) {
        isLoading = false
        
        let utterance = AVSpeechUtterance(string: text)
        let langCode: String
        switch language {
        case .english: langCode = "en-US"
        case .spanish: langCode = "es-ES"
        case .french: langCode = "fr-FR"
        case .german: langCode = "de-DE"
        case .italian: langCode = "it-IT"
        case .portuguese: langCode = "pt-PT"
        case .japanese: langCode = "ja-JP"
        }
        utterance.voice = AVSpeechSynthesisVoice(language: langCode)
        utterance.rate = 0.5
        
        speechSynthesizer.delegate = self
        speechSynthesizer.speak(utterance)
        isPlaying = true
        isPaused = false
    }
    
    func pause() {
        audioPlayer?.pause()
        speechSynthesizer.pauseSpeaking(at: .immediate)
        isPlaying = false
        isPaused = true
    }
    
    func stop() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        speechSynthesizer.stopSpeaking(at: .immediate)
        isPlaying = false
        isPaused = false
    }
}

extension AudioPlayerViewModel: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        isPaused = false
    }
}

extension AudioPlayerViewModel: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isPlaying = false
        isPaused = false
    }
}

#Preview {
    AudioPlayerView(
        text: "Once upon a time, there was a little girl named Sofia.",
        language: .spanish,
        voice: nil
    )
    .padding()
}

