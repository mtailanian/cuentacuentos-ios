import UIKit
import SwiftUI

struct HapticManager {
    static func impact(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}

extension View {
    func hapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium, onTap: @escaping () -> Void) -> some View {
        self.onTapGesture {
            HapticManager.impact(style: style)
            onTap()
        }
    }
}

