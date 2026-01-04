import SwiftUI

struct ChatInputView: View {
    @Binding var message: String
    @Binding var length: StoryFormValues.StoryLength
    let onSubmit: () -> Void
    let isLoading: Bool
    @FocusState private var isInputFocused: Bool
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 0) {
            // Quick settings bar
            if !isInputFocused {
                quickSettingsBar
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
            }
            
            // Input area
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .center, spacing: 12) {
                    // Text input - single line like ChatGPT
                    TextField("chat.input.placeholder".localized, text: $message)
                        .font(AppTheme.roundedFont(.body))
                        .textFieldStyle(.plain)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray6))
                        .cornerRadius(22)
                        .focused($isInputFocused)
                        .onSubmit {
                            if !message.isEmpty && !isLoading {
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
                            .fill(message.isEmpty || isLoading ? AnyShapeStyle(Color(.systemGray4)) : AnyShapeStyle(themeManager.current.accentGradient))
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
                    .disabled(message.isEmpty || isLoading)
                    .buttonStyle(.plain)
                }
                
                // Hint text when input is empty
                if message.isEmpty && !isInputFocused {
                    Text("chat.input.hint".localized)
                        .font(AppTheme.roundedFont(.caption))
                        .foregroundColor(.secondary.opacity(0.7))
                        .padding(.horizontal, 20)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
        }
        .background(
            Color(.systemBackground)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: -5)
        )
    }
    
    private var quickSettingsBar: some View {
        HStack(spacing: 12) {
            // Length selector
            Menu {
                ForEach(StoryFormValues.StoryLength.allCases, id: \.self) { len in
                    Button {
                        length = len
                    } label: {
                        HStack {
                            Text(len.displayName)
                            if length == len {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "text.alignleft")
                        .font(.system(size: 12))
                    Text(length.displayName)
                        .font(AppTheme.roundedFont(.caption, weight: .semibold))
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10))
                }
                .foregroundColor(.primary)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color(.systemGray6))
                .cornerRadius(16)
            }
            
            Spacer()
        }
    }
}

#Preview {
    ChatInputView(
        message: .constant(""),
        length: .constant(.medium),
        onSubmit: {},
        isLoading: false
    )
    .environmentObject(ThemeManager())
}

