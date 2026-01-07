import SwiftUI

struct QuickActionChip: View {
    let text: String
    let icon: String
    let onTap: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button {
            HapticManager.selection()
            onTap()
        } label: {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .semibold))
                Text(text)
                    .font(AppTheme.roundedFont(.caption, weight: .semibold))
            }
            .foregroundColor(.primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(20)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack {
        QuickActionChip(
            text: "Make it longer",
            icon: "arrow.up.circle.fill",
            onTap: {}
        )
    }
    .padding()
    .environmentObject(ThemeManager())
}

