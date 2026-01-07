import SwiftUI
import Combine
import AVFoundation

@MainActor
class PlayerManager: ObservableObject {
    static let shared = PlayerManager()
    
    @Published var currentStory: Story? {
        didSet {
            // Save the last played story ID when it changes
            let storageService = StorageService()
            storageService.saveLastPlayedStoryId(currentStory?.id)
        }
    }
    @Published var isPlaying = false
    @Published var isPaused = false
    @Published var isLoading = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var showFullPlayer = false
    @Published var playbackRate: Double = 1.0
    
    let player = AudioPlayerViewModel()
    private var progressTimer: Timer?
    private var cancellables = Set<AnyCancellable>()
    private let storageService = StorageService()
    
    private init() {
        setupObservers()
        setupProgressTracking()
    }
    
    private func setupObservers() {
        player.$isPlaying
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.isPlaying = value
            }
            .store(in: &cancellables)
        
        player.$isPaused
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.isPaused = value
            }
            .store(in: &cancellables)
        
        player.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.isLoading = value
            }
            .store(in: &cancellables)
    }
    
    private func setupProgressTracking() {
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateProgress()
            }
        }
    }
    
    private func updateProgress() {
        if let audioPlayer = player.audioPlayer {
            currentTime = audioPlayer.currentTime
            duration = audioPlayer.duration
        }
    }
    
    func play(story: Story, voice: Story.Voice? = nil) {
        currentStory = story
        let voiceToUse = voice ?? story.voice ?? .auto
        Task {
            await player.play(text: story.content, language: story.language, voice: voiceToUse == .auto ? nil : voiceToUse, storyId: story.id)
        }
    }
    
    func pause() {
        player.pause()
    }
    
    func resume() {
        player.resume()
    }
    
    func stop() {
        player.stop()
        currentTime = 0
        currentStory = nil
    }
    
    func seek(to time: TimeInterval) {
        player.seek(to: time)
        currentTime = time
    }
    
    func setPlaybackRate(_ rate: Double) {
        playbackRate = rate
        player.setPlaybackRate(rate)
    }
    
    func restoreLastPlayedStory(from savedStories: [Story]) {
        guard let lastPlayedId = storageService.loadLastPlayedStoryId() else {
            return
        }
        
        // Find the story in saved stories
        if let story = savedStories.first(where: { $0.id == lastPlayedId }) {
            currentStory = story
        }
    }
}

