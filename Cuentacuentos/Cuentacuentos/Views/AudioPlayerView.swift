import SwiftUI
import AVFoundation
import Combine

class AudioPlayerViewModel: NSObject, ObservableObject {
    @Published var isPlaying = false
    @Published var isPaused = false
    @Published var isLoading = false
    
    var audioPlayer: AVAudioPlayer?
    private var speechSynthesizer = AVSpeechSynthesizer()
    private let storyService = StoryService()
    private let storageService = StorageService()
    private var currentStoryId: String?
    
    override init() {
        super.init()
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
    }
    
    func play(text: String, language: Story.Language, voice: Story.Voice?, storyId: String? = nil) async {
        currentStoryId = storyId
        
        await MainActor.run {
            isLoading = true
            isPlaying = false
            isPaused = false
        }
        
        // Check cache first if we have a story ID
        if let storyId = storyId {
            if let cachedAudioData = storageService.loadAudioData(for: storyId, voice: voice) {
                await MainActor.run {
                    do {
                        audioPlayer = try AVAudioPlayer(data: cachedAudioData)
                        audioPlayer?.delegate = self
                        audioPlayer?.enableRate = true
                        audioPlayer?.rate = 1.0
                        audioPlayer?.prepareToPlay()
                        audioPlayer?.play()
                        isLoading = false
                        isPlaying = true
                        isPaused = false
                        print("Playing audio from cache")
                        return
                    } catch {
                        print("Error playing cached audio: \(error)")
                        // Fall through to generate new audio
                    }
                }
            }
        }
        
        // Generate new audio if not cached
        do {
            let audioData = try await storyService.generateTTS(
                text: text,
                language: language,
                voice: voice
            )
            
            // Save to cache if we have a story ID
            if let storyId = storyId {
                storageService.saveAudioData(audioData, for: storyId, voice: voice)
            }
            
            await MainActor.run {
                do {
                    audioPlayer = try AVAudioPlayer(data: audioData)
                    audioPlayer?.delegate = self
                    audioPlayer?.enableRate = true
                    audioPlayer?.rate = 1.0
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
    
    func resume() {
        if let audioPlayer = audioPlayer {
            audioPlayer.enableRate = true
            audioPlayer.rate = Float(1.0) // Will be updated by setPlaybackRate if needed
            audioPlayer.play()
        }
        speechSynthesizer.continueSpeaking()
        isPlaying = true
        isPaused = false
    }
    
    func stop() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        speechSynthesizer.stopSpeaking(at: .immediate)
        isPlaying = false
        isPaused = false
    }
    
    func seek(to time: TimeInterval) {
        audioPlayer?.currentTime = time
    }
    
    func setPlaybackRate(_ rate: Double) {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.enableRate = true
        audioPlayer.rate = Float(rate)
        // Note: AVSpeechSynthesizer doesn't support rate changes easily,
        // so rate changes only work with AVAudioPlayer (TTS audio)
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

