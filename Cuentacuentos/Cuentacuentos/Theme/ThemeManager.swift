import SwiftUI
import Combine

@MainActor
final class ThemeManager: ObservableObject {
    @Published var current: ThemeVariant = .morning {
        didSet {
            UserDefaults.standard.set(current.rawValue, forKey: themeKey)
        }
    }
    
    private let themeKey = "AppTheme"
    
    init() {
        // Load saved theme preference
        if let savedThemeRaw = UserDefaults.standard.string(forKey: themeKey),
           let savedTheme = ThemeVariant(rawValue: savedThemeRaw) {
            current = savedTheme
        }
    }
}

