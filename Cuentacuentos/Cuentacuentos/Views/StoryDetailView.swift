import SwiftUI
import UIKit

struct StoryDetailView: View {
    let story: Story
    
    var body: some View {
        ScrollView {
            StoryDisplayView(
                story: story,
                onSave: {},
                onShare: {
                    shareStory(story)
                }
            )
        }
        .navigationTitle(story.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func shareStory(_ story: Story) {
        let shareText = "\(story.title)\n\n\(story.content)"
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true)
        }
    }
}

