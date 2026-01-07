import SwiftUI
import UIKit

extension Story {
    /// Shares the story using UIActivityViewController
    func share() {
        let shareText = "\(title)\n\n\(content)"
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true)
        }
    }
    
    /// Returns formatted metadata string: "For [name] · Age [age] · [language]"
    var formattedMetadata: String {
        "\("story.for".localized) \(name) · \("story.age".localized) \(age) · \(language.displayName)"
    }
    
    /// Returns formatted metadata string with only name: "For [name]"
    var formattedMetadataShort: String {
        "\("story.for".localized) \(name)"
    }
}

extension TimeInterval {
    /// Formats time interval as MM:SS string
    func formattedTime() -> String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

extension StoryFormValues.StoryLength {
    /// Returns the number of visual bars for the length selector
    var barCount: Int {
        switch self {
        case .short: return 2
        case .medium: return 3
        case .long: return 4
        }
    }
    
    /// Returns the word count string for the length
    var wordCount: String {
        switch self {
        case .short: return "~250"
        case .medium: return "~400"
        case .long: return "~600"
        }
    }
}

extension View {
    /// Dismisses the keyboard
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    /// Adds a gesture to dismiss keyboard on drag down
    func dismissKeyboardOnDrag() -> some View {
        self.simultaneousGesture(
            DragGesture(minimumDistance: 20)
                .onEnded { value in
                    if value.translation.height > 100 {
                        dismissKeyboard()
                    }
                }
        )
    }
    
    /// Adds a gesture to dismiss keyboard on tap
    func dismissKeyboardOnTap() -> some View {
        self.simultaneousGesture(
            TapGesture()
                .onEnded {
                    dismissKeyboard()
                }
        )
    }
}

