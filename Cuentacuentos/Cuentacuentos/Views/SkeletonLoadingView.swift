import SwiftUI

struct SkeletonLoadingView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            // Header skeleton
            HStack(spacing: 14) {
                SkeletonBox(width: 60, height: 60, shape: .circle)
                VStack(alignment: .leading, spacing: 6) {
                    SkeletonBox(width: 200, height: 20)
                    SkeletonBox(width: 150, height: 16)
                }
                Spacer()
            }
            .padding()
            .background(AppTheme.Colors.surface)
            .cornerRadius(AppTheme.Radii.large)
            
            // Form skeleton
            VStack(spacing: 20) {
                SkeletonBox(width: .infinity, height: 110)
                SkeletonBox(width: .infinity, height: 60)
                SkeletonBox(width: .infinity, height: 50)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            
            // Button skeleton
            SkeletonBox(width: .infinity, height: 50)
        }
        .padding()
    }
}

struct StorySkeletonView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title skeleton
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    SkeletonBox(width: 100, height: 14)
                    SkeletonBox(width: 200, height: 24)
                    SkeletonBox(width: 180, height: 16)
                }
                Spacer()
                VStack(spacing: 8) {
                    SkeletonBox(width: 60, height: 32)
                    SkeletonBox(width: 60, height: 32)
                }
            }
            
            // Content skeleton
            VStack(alignment: .leading, spacing: 12) {
                SkeletonBox(width: .infinity, height: 16)
                SkeletonBox(width: .infinity, height: 16)
                SkeletonBox(width: 300, height: 16)
                SkeletonBox(width: .infinity, height: 16)
                SkeletonBox(width: 250, height: 16)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            
            // Playback skeleton
            VStack(spacing: 12) {
                HStack {
                    SkeletonBox(width: 120, height: 16)
                    Spacer()
                    SkeletonBox(width: 100, height: 30)
                }
                SkeletonBox(width: .infinity, height: 50)
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [
                        AppTheme.Colors.primary.opacity(0.18),
                        AppTheme.Colors.secondary.opacity(0.16)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(AppTheme.Radii.large)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

struct SkeletonBox: View {
    let width: CGFloat?
    let height: CGFloat
    var shape: SkeletonShape = .roundedRectangle
    
    @State private var isAnimating = false
    
    enum SkeletonShape {
        case roundedRectangle
        case circle
    }
    
    var body: some View {
        Group {
            switch shape {
            case .roundedRectangle:
                RoundedRectangle(cornerRadius: AppTheme.Radii.medium)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.gray.opacity(0.2),
                                Color.gray.opacity(0.3),
                                Color.gray.opacity(0.2)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: width, height: height)
                    .shimmer(isAnimating: isAnimating)
            case .circle:
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.gray.opacity(0.2),
                                Color.gray.opacity(0.3),
                                Color.gray.opacity(0.2)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: width, height: height)
                    .shimmer(isAnimating: isAnimating)
            }
        }
        .onAppear {
            withAnimation(
                Animation.linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
            ) {
                isAnimating = true
            }
        }
    }
}

extension View {
    func shimmer(isAnimating: Bool) -> some View {
        self.modifier(ShimmerModifier(isAnimating: isAnimating))
    }
}

struct ShimmerModifier: ViewModifier {
    let isAnimating: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        colors: [
                            Color.clear,
                            Color.white.opacity(0.4),
                            Color.clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 2)
                    .offset(x: isAnimating ? geometry.size.width : -geometry.size.width)
                }
            )
            .clipped()
    }
}

#Preview {
    VStack {
        SkeletonLoadingView()
        StorySkeletonView()
    }
    .environmentObject(ThemeManager())
}

