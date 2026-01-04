import SwiftUI

struct SplashView: View {
    let onStart: () -> Void
    @State private var isActive = true
    
    var body: some View {
        ZStack {
            AppTheme.Colors.softBackground
                .ignoresSafeArea()
            
            VStack(spacing: 28) {
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(AppTheme.Colors.secondary.opacity(0.18))
                            .frame(width: 120, height: 120)
                        Image(systemName: "sparkles")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(AppTheme.Colors.secondary)
                    }
                    
                    VStack(spacing: 10) {
                        Text("splash.title".localized)
                            .font(AppTheme.roundedFont(.title, weight: .bold))
                            .multilineTextAlignment(.center)
                        Text("splash.subtitle".localized)
                            .font(AppTheme.roundedFont(.body))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                if isActive {
                    onStart()
                }
            }
        }
        .onDisappear {
            isActive = false
        }
    }
}
