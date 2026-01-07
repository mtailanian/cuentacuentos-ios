import SwiftUI

struct ChatInputView: View {
    @Binding var message: String
    let onSubmit: () -> Void
    let isLoading: Bool
    let hasCurrentStory: Bool // New parameter to determine placeholder
    let onNewStory: (() -> Void)? // New callback for new story button
    @FocusState private var isInputFocused: Bool
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 0) {
            // Input area
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .center, spacing: 12) {
                    // New Story button (like ChatGPT) - only show when there are messages
                    if let onNewStory = onNewStory {
                        Button {
                            HapticManager.impact(style: .light)
                            onNewStory()
                        } label: {
                            ZStack {
                                Circle()
                                    .stroke(Color.secondary.opacity(0.3), lineWidth: 1.5)
                                    .frame(width: 32, height: 32)
                                Image(systemName: "plus")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                    
                    // Text input - single line like ChatGPT
                    TextField(
                        hasCurrentStory ? "chat.input.placeholder.modify".localized : "chat.input.placeholder".localized,
                        text: $message
                    )
                        .font(AppTheme.roundedFont(.body))
                        .textFieldStyle(.plain)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray6))
                        .cornerRadius(22)
                        .focused($isInputFocused)
                        .onSubmit {
                            if (!message.isEmpty || !hasCurrentStory) && !isLoading {
                                onSubmit()
                            }
                        }
                    
                    // Send button
                Button {
                    HapticManager.impact(style: .medium)
                    onSubmit()
                } label: {
                    ZStack {
                        Circle()
                            .fill((message.isEmpty && hasCurrentStory) || isLoading ? AnyShapeStyle(Color(.systemGray4)) : AnyShapeStyle(themeManager.current.accentGradient))
                            .frame(width: 44, height: 44)
                        
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "arrow.up")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    }
                    .disabled((message.isEmpty && hasCurrentStory) || isLoading)
                    .buttonStyle(.plain)
                }
                
                // Hint text when input is empty (only for new stories, not modifications)
                if message.isEmpty && !isInputFocused && !hasCurrentStory {
                    Text("chat.input.hint".localized)
                        .font(AppTheme.roundedFont(.caption))
                        .foregroundColor(.secondary.opacity(0.7))
                        .padding(.horizontal, 20)
                        .padding(.top, 4)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
        }
    }
}

#Preview {
    ChatInputView(
        message: .constant(""),
        onSubmit: {},
        isLoading: false,
        hasCurrentStory: false,
        onNewStory: nil
    )
    .environmentObject(ThemeManager())
}

