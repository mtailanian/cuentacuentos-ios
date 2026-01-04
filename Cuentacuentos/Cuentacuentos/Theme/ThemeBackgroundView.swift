import SwiftUI
import UIKit

struct ThemeBackgroundView: View {
    let theme: ThemeVariant
    private let shapeOpacity: Double = 0.08
    private let particleOpacity: Double = 0.10
    
    var body: some View {
        ZStack {
            if let imageName = theme.backgroundImageName,
               let uiImage = UIImage(named: imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                theme.background
                    .ignoresSafeArea()
                    .opacity(0.35)
            } else {
                theme.background
                    .ignoresSafeArea()
            }
            
            // Decorative shapes
            GeometryReader { proxy in
                let size = proxy.size
                
                if theme.backgroundImageName == nil {
                    Group {
                        shape(for: theme, size: size, index: 0)
                        shape(for: theme, size: size, index: 1)
                        shape(for: theme, size: size, index: 2)
                    }
                    .opacity(shapeOpacity)
                    
                    // Light sparkles/particles
                    Group {
                        particle(at: CGPoint(x: size.width * 0.18, y: size.height * 0.22))
                        particle(at: CGPoint(x: size.width * 0.72, y: size.height * 0.18))
                        particle(at: CGPoint(x: size.width * 0.35, y: size.height * 0.62))
                        particle(at: CGPoint(x: size.width * 0.68, y: size.height * 0.75))
                        particle(at: CGPoint(x: size.width * 0.82, y: size.height * 0.48))
                    }
                    .opacity(particleOpacity)
                    
                    // Theme-specific overlays
                    switch theme {
                    case .ocean:
                        oceanOverlay(size: size)
                    case .galaxy:
                        galaxyOverlay(size: size)
                    default:
                        EmptyView()
                    }
                }
            }
        }
        .allowsHitTesting(false)
    }
    
    @ViewBuilder
    private func shape(for theme: ThemeVariant, size: CGSize, index: Int) -> some View {
        let width = size.width
        let height = size.height
        switch theme {
        case .morning, .sunset:
            RoundedRectangle(cornerRadius: 120, style: .continuous)
                .fill(theme.accentGradient)
                .frame(width: max(width * 0.65, 240), height: max(height * 0.35, 180))
                .rotationEffect(.degrees(index == 0 ? -12 : index == 1 ? 8 : 22))
                .offset(x: offsetX(width: width, index: index),
                        y: offsetY(height: height, index: index))
        case .night, .galaxy:
            Circle()
                .fill(theme.accentGradient)
                .frame(width: max(width * 0.45, 180))
                .offset(x: offsetX(width: width, index: index),
                        y: offsetY(height: height, index: index))
        case .forest:
            Ellipse()
                .fill(theme.accentGradient)
                .frame(width: max(width * 0.60, 220), height: max(height * 0.28, 140))
                .offset(x: offsetX(width: width, index: index),
                        y: offsetY(height: height, index: index))
        case .candy:
            Capsule(style: .continuous)
                .fill(theme.accentGradient)
                .frame(width: max(width * 0.55, 200), height: 90)
                .rotationEffect(.degrees(index == 0 ? 10 : -15))
                .offset(x: offsetX(width: width, index: index),
                        y: offsetY(height: height, index: index))
        case .ocean:
            RoundedRectangle(cornerRadius: 80, style: .continuous)
                .fill(theme.accentGradient)
                .frame(width: max(width * 0.70, 240), height: max(height * 0.30, 150))
                .rotationEffect(.degrees(index == 0 ? -18 : 12))
                .offset(x: offsetX(width: width, index: index),
                        y: offsetY(height: height, index: index))
        }
    }
    
    private func offsetX(width: CGFloat, index: Int) -> CGFloat {
        switch index {
        case 0: return -width * 0.25
        case 1: return width * 0.30
        default: return width * 0.05
        }
    }
    
    private func offsetY(height: CGFloat, index: Int) -> CGFloat {
        switch index {
        case 0: return -height * 0.25
        case 1: return height * 0.08
        default: return height * 0.30
        }
    }
    
    @ViewBuilder
    private func particle(at point: CGPoint) -> some View {
        Circle()
            .fill(theme.sparkleColor)
            .frame(width: 10, height: 10)
            .position(point)
        Circle()
            .stroke(theme.sparkleColor.opacity(0.6), lineWidth: 2)
            .frame(width: 18, height: 18)
            .position(point)
    }
    
    // MARK: - Theme-specific overlays
    
    @ViewBuilder
    private func oceanOverlay(size: CGSize) -> some View {
        let w = size.width
        let h = size.height
        ZStack {
            wave(y: h * 0.78, amplitude: 12, frequency: 1.2)
                .fill(Color.white.opacity(0.14))
            wave(y: h * 0.82, amplitude: 16, frequency: 1.4)
                .fill(Color.white.opacity(0.10))
            wave(y: h * 0.86, amplitude: 20, frequency: 1.1)
                .fill(Color.white.opacity(0.08))
        }
        .frame(width: w, height: h)
    }
    
    @ViewBuilder
    private func galaxyOverlay(size: CGSize) -> some View {
        let w = size.width
        let h = size.height
        ZStack {
            // Nebula glow
            Circle()
                .fill(theme.accentGradient)
                .blur(radius: 90)
                .frame(width: w * 0.6, height: w * 0.6)
                .offset(x: w * 0.25, y: -h * 0.2)
            Circle()
                .fill(theme.sparkleColor.opacity(0.6))
                .blur(radius: 70)
                .frame(width: w * 0.4, height: w * 0.4)
                .offset(x: -w * 0.2, y: h * 0.05)
            
            // Star field
            ForEach(0..<24, id: \.self) { idx in
                let x = CGFloat(idx % 6) / 6.0 * w + 20
                let y = CGFloat(idx / 6) / 4.0 * h + 20
                Circle()
                    .fill(Color.white.opacity(0.85))
                    .frame(width: 3, height: 3)
                    .position(x: x, y: y)
            }
            ForEach(0..<8, id: \.self) { idx in
                let x = CGFloat(idx) / 8.0 * w + 10
                let y = h * 0.3 + CGFloat(idx) * 14
                Circle()
                    .fill(theme.sparkleColor.opacity(0.9))
                    .frame(width: 5, height: 5)
                    .position(x: x, y: y)
            }
        }
        .frame(width: w, height: h)
    }
    
    private func wave(y: CGFloat, amplitude: CGFloat, frequency: CGFloat) -> Path {
        Path { path in
            let width: CGFloat = 1200
            path.move(to: CGPoint(x: -100, y: y))
            let step: CGFloat = 20
            var x: CGFloat = -100
            while x <= width {
                let relative = x / width
                let angle = relative * .pi * frequency * 2
                let yOffset = sin(angle) * amplitude
                path.addLine(to: CGPoint(x: x, y: y + yOffset))
                x += step
            }
            path.addLine(to: CGPoint(x: width + 100, y: y + 200))
            path.addLine(to: CGPoint(x: -100, y: y + 200))
            path.closeSubpath()
        }
    }
}

