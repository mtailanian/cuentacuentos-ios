import SwiftUI

enum ThemeVariant: String, CaseIterable, Identifiable {
    case morning
    case sunset
    case night
    case forest
    case candy
    case ocean
    case galaxy
    
    var id: String { rawValue }
    
    var displayNameKey: String {
        switch self {
        case .morning: return "theme.morning"
        case .sunset: return "theme.sunset"
        case .night: return "theme.night"
        case .forest: return "theme.forest"
        case .candy: return "theme.candy"
        case .ocean: return "theme.ocean"
        case .galaxy: return "theme.galaxy"
        }
    }
    
    var backgroundImageName: String? {
        switch self {
        case .ocean: return "bg_waves"
        case .galaxy: return "bg_galaxy"
        default: return nil
        }
    }
    
    var background: LinearGradient {
        switch self {
        case .morning:
            return LinearGradient(
                colors: [
                    Color(red: 0.90, green: 0.96, blue: 1.0),
                    Color.white,
                    Color(red: 1.0, green: 0.95, blue: 0.90)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .sunset:
            return LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.86, blue: 0.73),
                    Color(red: 1.0, green: 0.70, blue: 0.62),
                    Color(red: 0.96, green: 0.82, blue: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        case .night:
            return LinearGradient(
                colors: [
                    Color(red: 0.14, green: 0.16, blue: 0.32),
                    Color(red: 0.10, green: 0.11, blue: 0.22),
                    Color(red: 0.07, green: 0.08, blue: 0.18)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        case .forest:
            return LinearGradient(
                colors: [
                    Color(red: 0.80, green: 0.93, blue: 0.82),
                    Color(red: 0.67, green: 0.86, blue: 0.74),
                    Color(red: 0.56, green: 0.76, blue: 0.62)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        case .candy:
            return LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.88, blue: 0.96),
                    Color(red: 1.0, green: 0.76, blue: 0.89),
                    Color(red: 0.95, green: 0.67, blue: 0.94)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .ocean:
            return LinearGradient(
                colors: [
                    Color(red: 0.83, green: 0.94, blue: 1.0),
                    Color(red: 0.60, green: 0.84, blue: 1.0),
                    Color(red: 0.43, green: 0.72, blue: 0.96)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        case .galaxy:
            return LinearGradient(
                colors: [
                    Color(red: 0.13, green: 0.12, blue: 0.23),
                    Color(red: 0.23, green: 0.15, blue: 0.36),
                    Color(red: 0.32, green: 0.18, blue: 0.48)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    var accentGradient: LinearGradient {
        switch self {
        case .morning:
            return LinearGradient(
                colors: [
                    Color(red: 0.36, green: 0.74, blue: 1.0),
                    Color(red: 0.98, green: 0.56, blue: 0.28)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        case .sunset:
            return LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.58, blue: 0.46),
                    Color(red: 0.98, green: 0.46, blue: 0.66)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        case .night:
            return LinearGradient(
                colors: [
                    Color(red: 0.40, green: 0.62, blue: 1.0),
                    Color(red: 0.55, green: 0.42, blue: 0.90)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        case .forest:
            return LinearGradient(
                colors: [
                    Color(red: 0.36, green: 0.75, blue: 0.55),
                    Color(red: 0.22, green: 0.62, blue: 0.43)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        case .candy:
            return LinearGradient(
                colors: [
                    Color(red: 0.99, green: 0.53, blue: 0.71),
                    Color(red: 0.96, green: 0.38, blue: 0.55)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        case .ocean:
            return LinearGradient(
                colors: [
                    Color(red: 0.24, green: 0.67, blue: 0.96),
                    Color(red: 0.18, green: 0.51, blue: 0.82)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        case .galaxy:
            return LinearGradient(
                colors: [
                    Color(red: 0.69, green: 0.56, blue: 1.0),
                    Color(red: 0.41, green: 0.58, blue: 1.0)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }
    
    var accentColor: Color {
        switch self {
        case .morning: return Color(red: 0.13, green: 0.53, blue: 0.95)
        case .sunset: return Color(red: 0.95, green: 0.45, blue: 0.55)
        case .night: return Color(red: 0.55, green: 0.70, blue: 1.0)
        case .forest: return Color(red: 0.22, green: 0.62, blue: 0.43)
        case .candy: return Color(red: 0.96, green: 0.38, blue: 0.55)
        case .ocean: return Color(red: 0.18, green: 0.51, blue: 0.82)
        case .galaxy: return Color(red: 0.55, green: 0.68, blue: 1.0)
        }
    }
    
    var sparkleColor: Color {
        switch self {
        case .morning: return Color(red: 0.98, green: 0.56, blue: 0.28)
        case .sunset: return Color(red: 1.0, green: 0.72, blue: 0.40)
        case .night: return Color(red: 0.70, green: 0.80, blue: 1.0)
        case .forest: return Color(red: 0.36, green: 0.75, blue: 0.55)
        case .candy: return Color(red: 1.0, green: 0.68, blue: 0.84)
        case .ocean: return Color(red: 0.43, green: 0.72, blue: 0.96)
        case .galaxy: return Color(red: 0.90, green: 0.70, blue: 1.0)
        }
    }
}

