import SwiftUI

struct AppGradients {
    static let hero = LinearGradient(
        colors: [
            Color(red: 0.90, green: 0.96, blue: 1.0),
            Color(red: 1.0, green: 0.95, blue: 0.90),
            Color(red: 0.96, green: 0.92, blue: 1.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let accent = LinearGradient(
        colors: [
            Color(red: 0.36, green: 0.74, blue: 1.0),
            Color(red: 0.98, green: 0.56, blue: 0.28)
        ],
        startPoint: .leading,
        endPoint: .trailing
    )
    
    static let chipActive = LinearGradient(
        colors: [
            Color(red: 0.98, green: 0.56, blue: 0.28),
            Color(red: 0.46, green: 0.80, blue: 0.44)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

