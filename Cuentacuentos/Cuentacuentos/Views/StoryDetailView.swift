import SwiftUI
import UIKit

struct StoryDetailView: View {
    let story: Story
    let onToggleFavorite: (() -> Void)?
    
    @State private var currentStory: Story
    private let storageService = StorageService()
    
    init(story: Story, onToggleFavorite: (() -> Void)?) {
        self.story = story
        self.onToggleFavorite = onToggleFavorite
        _currentStory = State(initialValue: story)
    }
    
    var body: some View {
        ScrollView {
            StoryDisplayView(
                story: currentStory,
                onSave: nil, // No save button for saved stories
                onShare: {
                    currentStory.share()
                },
                onToggleFavorite: {
                    // Update local state immediately for instant UI feedback
                    var updatedStory = currentStory
                    updatedStory.isFavorite.toggle()
                    currentStory = updatedStory
                    
                    // Call the parent callback to update saved stories
                    onToggleFavorite?()
                    
                    // Refresh from storage after a brief delay to ensure sync
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        refreshStoryFromStorage()
                    }
                }
            )
        }
        .navigationTitle(currentStory.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            refreshStoryFromStorage()
        }
    }
    
    private func refreshStoryFromStorage() {
        let savedStories = storageService.loadStories()
        if let updatedStory = savedStories.first(where: { $0.id == currentStory.id }) {
            currentStory = updatedStory
        }
    }
}

