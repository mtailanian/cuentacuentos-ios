import SwiftUI

struct AppTheme {
    struct Colors {
        static let primary = Color(red: 0.13, green: 0.53, blue: 0.95)      // Bright blue
        static let secondary = Color(red: 0.98, green: 0.56, blue: 0.28)    // Warm orange
        static let accent = Color(red: 0.46, green: 0.80, blue: 0.44)       // Playful green
        static let softBackground = LinearGradient(
            colors: [
                Color(red: 0.90, green: 0.96, blue: 1.0),
                Color.white,
                Color(red: 1.0, green: 0.95, blue: 0.90)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        static let surface = Color.white
        static let subtleShadow = Color.black.opacity(0.08)
    }
    
    struct Radii {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let pill: CGFloat = 999
    }
    
    static func roundedFont(_ style: Font.TextStyle, weight: Font.Weight = .regular) -> Font {
        // SF Rounded via design, fall back to system if unavailable
        switch style {
        case .largeTitle: return .system(.largeTitle, design: .rounded).weight(weight)
        case .title: return .system(.title, design: .rounded).weight(weight)
        case .title2: return .system(.title2, design: .rounded).weight(weight)
        case .title3: return .system(.title3, design: .rounded).weight(weight)
        case .headline: return .system(.headline, design: .rounded).weight(weight)
        case .subheadline: return .system(.subheadline, design: .rounded).weight(weight)
        case .body: return .system(.body, design: .rounded).weight(weight)
        case .callout: return .system(.callout, design: .rounded).weight(weight)
        case .footnote: return .system(.footnote, design: .rounded).weight(weight)
        case .caption: return .system(.caption, design: .rounded).weight(weight)
        case .caption2: return .system(.caption2, design: .rounded).weight(weight)
        @unknown default: return .system(.body, design: .rounded).weight(weight)
        }
    }
}

