import Foundation
import Combine

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: Story.Language = .spanish {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: languageKey)
        }
    }
    
    private let languageKey = "AppUILanguage"
    
    private init() {
        // Load saved language preference
        if let savedLanguageRaw = UserDefaults.standard.string(forKey: languageKey),
           let savedLanguage = Story.Language(rawValue: savedLanguageRaw) {
            currentLanguage = savedLanguage
        }
    }
    
    func setLanguage(_ language: Story.Language) {
        currentLanguage = language
    }
    
    func localizedString(_ key: String) -> String {
        return LocalizedStrings.string(for: key, language: currentLanguage)
    }
}

// Convenience extension for easy access
extension String {
    var localized: String {
        return LocalizationManager.shared.localizedString(self)
    }
}

