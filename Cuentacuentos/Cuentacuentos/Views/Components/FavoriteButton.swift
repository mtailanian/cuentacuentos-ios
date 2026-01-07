import SwiftUI

struct FavoriteButton: View {
    let isFavorite: Bool
    let onToggle: () -> Void
    var size: CGFloat = 36
    var iconSize: CGFloat = 16
    
    var body: some View {
        Button {
            HapticManager.notification(type: isFavorite ? .warning : .success)
            onToggle()
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.system(size: iconSize, weight: .semibold))
                .foregroundColor(isFavorite ? .red : .secondary)
                .frame(width: size, height: size)
                .background(isFavorite ? Color.red.opacity(0.1) : Color(.systemGray6))
                .cornerRadius(size / 2)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack {
        FavoriteButton(isFavorite: false, onToggle: {})
        FavoriteButton(isFavorite: true, onToggle: {})
        FavoriteButton(isFavorite: false, onToggle: {}, size: 44, iconSize: 18)
    }
    .padding()
}

