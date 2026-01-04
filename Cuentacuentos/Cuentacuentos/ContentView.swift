import SwiftUI

struct ContentView: View {
    @StateObject private var storyService = StoryService()
    @StateObject private var localizationManager = LocalizationManager.shared
    @StateObject private var themeManager = ThemeManager()
    private let storageService = StorageService()
    
    @State private var formValues = StoryFormValues()
    @State private var isLoading = false
    @State private var error: String = ""
    @State private var currentStory: Story?
    @State private var savedStories: [Story] = []
    @State private var showSplash = true
    
    var body: some View {
        ZStack {
            TabView {
                GenerateStoryView(
                    formValues: $formValues,
                    isLoading: $isLoading,
                    error: $error,
                    currentStory: $currentStory,
                    onSubmit: handleSubmit,
                    onSave: handleSave,
                    onShare: handleShare
                )
                .tabItem {
                    Label("tab.generate".localized, systemImage: "sparkles")
                }
                
                SavedStoriesView(
                    savedStories: $savedStories,
                    onDelete: handleDelete,
                    onSelect: { story in
                        currentStory = story
                    }
                )
                .tabItem {
                    Label("tab.saved".localized, systemImage: "book.fill")
                }
                
                ProfileView()
                    .tabItem {
                        Label("tab.profile".localized, systemImage: "person.crop.circle")
                    }
            }
            .environmentObject(themeManager)
            .onAppear {
                loadSavedStories()
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
    }
    
    private func handleSubmit() {
        error = ""
        isLoading = true
        
        Task {
            do {
                guard let age = Int(formValues.age), age > 0 else {
                    await MainActor.run {
                        error = "form.age.error".localized
                        isLoading = false
                    }
                    return
                }
                
                let fallbackName = "form.default.name".localized
                let nameForStory = formValues.name.trimmingCharacters(in: .whitespaces).isEmpty ? fallbackName : formValues.name
                
                let response = try await storyService.generateStory(
                    name: nameForStory,
                    age: age,
                    brief: formValues.brief.isEmpty ? nil : formValues.brief,
                    randomTopic: formValues.randomTopic,
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
                }
            } catch {
                await MainActor.run {
                    self.error = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }
    
    private func handleSave() {
        guard let story = currentStory else { return }
        savedStories.insert(story, at: 0)
        storageService.saveStories(savedStories)
    }
    
    private func handleDelete(_ id: String) {
        savedStories.removeAll { $0.id == id }
        if currentStory?.id == id {
            currentStory = nil
        }
        storageService.saveStories(savedStories)
    }
    
    private func handleShare() {
        guard let story = currentStory else { return }
        let shareText = "\(story.title)\n\n\(story.content)"
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true)
        }
    }
}

#Preview {
    ContentView()
}

