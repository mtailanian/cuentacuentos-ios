import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarButton(
                icon: "sparkles",
                title: "tab.generate".localized,
                isSelected: selectedTab == 0,
                action: { selectedTab = 0 }
            )
            
            TabBarButton(
                icon: "book.fill",
                title: "tab.saved".localized,
                isSelected: selectedTab == 1,
                action: { selectedTab = 1 }
            )
            
            TabBarButton(
                icon: "person.circle",
                title: "tab.profile".localized,
                isSelected: selectedTab == 2,
                action: { selectedTab = 2 }
            )
        }
        .frame(height: 60)
        .background(
            Material.ultraThinMaterial
        )
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color.secondary.opacity(0.2)),
            alignment: .top
        )
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            HapticManager.selection()
            action()
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: isSelected ? .semibold : .regular))
                    .symbolVariant(isSelected ? .fill : .none)
                
                Text(title)
                    .font(AppTheme.roundedFont(.caption2, weight: isSelected ? .semibold : .regular))
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(isSelected ? .primary : .secondary)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(0))
        .environmentObject(ThemeManager())
}

