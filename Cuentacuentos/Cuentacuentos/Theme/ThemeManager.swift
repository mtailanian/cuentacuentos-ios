import SwiftUI
import Combine

@MainActor
final class ThemeManager: ObservableObject {
    @Published var current: ThemeVariant = .morning
    
    func setTheme(_ theme: ThemeVariant) {
        current = theme
    }
}

