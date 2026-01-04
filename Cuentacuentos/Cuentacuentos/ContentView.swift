import SwiftUI

struct ContentView: View {
    @StateObject private var storyService = StoryService()
    @StateObject private var localizationManager = LocalizationManager.shared
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var keyboardManager = KeyboardManager()
    @ObservedObject private var playerManager = PlayerManager.shared
    private let storageService = StorageService()
    
    @State private var formValues = StoryFormValues()
    @State private var isLoading = false
    @State private var error: String = ""
    @State private var currentStory: Story?
    @State private var savedStories: [Story] = []
    @State private var showSplash = true
    @State private var selectedTab = 0
    @State private var chatMessages: [ChatMessage] = []
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Main content area
                Group {
                    switch selectedTab {
                    case 0:
                        GenerateStoryView(
                            keyboardManager: keyboardManager,
                            formValues: $formValues,
                            isLoading: $isLoading,
                            error: $error,
                            currentStory: $currentStory,
                            messages: $chatMessages,
                            onSubmit: handleSubmit,
                            onSave: handleSave,
                            onShare: handleShare,
                            onToggleFavorite: {
                                handleToggleFavoriteForCurrentStory()
                            }
                        )
                    case 1:
                        SavedStoriesView(
                            savedStories: $savedStories,
                            onDelete: handleDelete,
                            onSelect: { story in
                                currentStory = story
                            },
                            onToggleFavorite: handleToggleFavorite,
                            onRefresh: loadSavedStories
                        )
                    case 2:
                        ProfileView()
                    default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Mini player (only show if there's a story to play, and hide when keyboard is visible on generate tab)
                Group {
                    if playerManager.currentStory != nil && !(keyboardManager.isVisible && selectedTab == 0) {
                        MiniPlayerView()
                            .environmentObject(themeManager)
                            .padding(.horizontal, 16)
                            .padding(.top, 8)
                            .padding(.bottom, 8)
                            .background(
                                Material.ultraThinMaterial
                            )
                            .overlay(
                                Rectangle()
                                    .frame(height: 0.5)
                                    .foregroundColor(Color.secondary.opacity(0.2)),
                                alignment: .top
                            )
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: keyboardManager.isVisible)
                .animation(.easeInOut(duration: 0.3), value: playerManager.currentStory != nil)
                
                // Custom tab bar (hide when keyboard is visible)
                Group {
                    if !keyboardManager.isVisible {
                        CustomTabBar(selectedTab: $selectedTab)
                            .environmentObject(themeManager)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: keyboardManager.isVisible)
            }
            .environmentObject(themeManager)
            .onAppear {
                loadSavedStories()
            }
            .fullScreenCover(isPresented: $playerManager.showFullPlayer) {
                FullPlayerView()
                    .environmentObject(themeManager)
            }
            
            if showSplash {
                SplashView {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showSplash = false
                    }
                }
                .transition(.opacity)
                .zIndex(1)
            }
        }
    }
    
    private func loadSavedStories() {
        savedStories = storageService.loadStories()
        // Restore last played story after loading saved stories
        playerManager.restoreLastPlayedStory(from: savedStories)
    }
    
    private func handleSubmit() {
        error = ""
        isLoading = true
        HapticManager.impact(style: .light)
        
        Task {
            do {
                // Get profile for default age and name
                let profile = storageService.loadProfile()
                let age = profile?.defaultAge ?? 6
                let fallbackName = profile?.name ?? "form.default.name".localized
                let nameForStory = formValues.name.trimmingCharacters(in: .whitespaces).isEmpty ? fallbackName : formValues.name
                
                // Empty brief means random topic
                let isRandomTopic = formValues.brief.trimmingCharacters(in: .whitespaces).isEmpty
                
                let response = try await storyService.generateStory(
                    name: nameForStory,
                    age: age,
                    brief: formValues.brief.isEmpty ? nil : formValues.brief,
                    randomTopic: isRandomTopic,
                    length: formValues.length,
                    language: localizationManager.currentLanguage
                )
                
                let newStory = Story(
                    id: UUID().uuidString,
                    title: response.title,
                    content: response.story,
                    createdAt: ISO8601DateFormatter().string(from: Date()),
                    name: nameForStory,
                    age: age,
                    language: localizationManager.currentLanguage,
                    voice: nil,
                    randomTopic: formValues.randomTopic,
                    brief: formValues.brief.isEmpty ? nil : formValues.brief
                )
                
                await MainActor.run {
                    currentStory = newStory
                    isLoading = false
                    
                    // Add assistant message with the story
                    let assistantMessage = ChatMessage(
                        role: .assistant,
                        content: "chat.story.generated".localized,
                        story: newStory
                    )
                    chatMessages.append(assistantMessage)
                }
            } catch {
                await MainActor.run {
                    self.error = error.localizedDescription
                    isLoading = false
                    
                    // Add error message to chat
                    let errorMessage = ChatMessage(
                        role: .assistant,
                        content: "chat.error.message".localized + ": \(error.localizedDescription)"
                    )
                    chatMessages.append(errorMessage)
                }
            }
        }
    }
    
    private func handleSave() {
        guard let story = currentStory else { return }
        
        // Check if story already exists (by ID)
        if let existingIndex = savedStories.firstIndex(where: { $0.id == story.id }) {
            // Update existing story
            savedStories[existingIndex] = story
        } else {
            // Add new story at the beginning
        savedStories.insert(story, at: 0)
        }
        
        // Save to storage
        storageService.saveStories(savedStories)
        
        // Verify save was successful
        let savedCount = storageService.loadStories().count
        print("Stories saved. Total stories in storage: \(savedCount)")
        
        HapticManager.notification(type: .success)
    }
    
    private func handleDelete(_ id: String) {
        HapticManager.impact(style: .medium)
        savedStories.removeAll { $0.id == id }
        if currentStory?.id == id {
            currentStory = nil
        }
        // Clear last played story if it was the deleted one
        if playerManager.currentStory?.id == id {
            playerManager.currentStory = nil
        }
        storageService.saveStories(savedStories)
    }
    
    private func handleShare() {
        guard let story = currentStory else { return }
        HapticManager.impact(style: .medium)
        let shareText = "\(story.title)\n\n\(story.content)"
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true)
        }
    }
    
    private func handleToggleFavorite(_ id: String) {
        if let index = savedStories.firstIndex(where: { $0.id == id }) {
            var updatedStory = savedStories[index]
            updatedStory.isFavorite.toggle()
            savedStories[index] = updatedStory
            storageService.saveStories(savedStories)
            
            // Update current story if it's the one being favorited
            if currentStory?.id == id {
                var updatedCurrentStory = currentStory!
                updatedCurrentStory.isFavorite = updatedStory.isFavorite
                currentStory = updatedCurrentStory
            }
        }
    }
    
    private func handleToggleFavoriteForCurrentStory() {
        guard let story = currentStory else { return }
        var updatedStory = story
        updatedStory.isFavorite.toggle()
        currentStory = updatedStory
        
        // Update the story in chatMessages array so the UI reflects the change
        if let messageIndex = chatMessages.firstIndex(where: { $0.story?.id == story.id }) {
            var updatedMessage = chatMessages[messageIndex]
            if updatedMessage.story != nil {
                updatedMessage.story = updatedStory
                chatMessages[messageIndex] = updatedMessage
            }
        }
        
        // Save or update the story in savedStories
        if let index = savedStories.firstIndex(where: { $0.id == story.id }) {
            // Story already exists, update it
            savedStories[index].isFavorite = updatedStory.isFavorite
        } else {
            // Story not saved yet, add it to saved stories
            savedStories.insert(updatedStory, at: 0)
        }
        storageService.saveStories(savedStories)
    }
}

#Preview {
    ContentView()
}

