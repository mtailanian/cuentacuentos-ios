import SwiftUI

struct GenerateStoryView: View {
    @ObservedObject var localizationManager: LocalizationManager = .shared
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var keyboardManager: KeyboardManager
    
    @Binding var formValues: StoryFormValues
    @Binding var isLoading: Bool
    @Binding var error: String
    @Binding var currentStory: Story?
    @Binding var messages: [ChatMessage]
    
    let onSubmit: () -> Void
    let onSave: () -> Void
    let onShare: () -> Void
    let onToggleFavorite: (() -> Void)?
    let onClearChat: () -> Void // New callback to clear chat
    
    @State private var inputMessage: String = ""
    @State private var scrollProxy: ScrollViewProxy?
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    ThemeBackgroundView(theme: themeManager.current)
                    
                    // Chat messages - full screen
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                // Top padding
                                Spacer()
                                    .frame(height: 8)
                                // Welcome message
                                if messages.isEmpty {
                                    welcomeMessage
                                        .padding(.top, 40)
                                }
                                
                                // Chat messages
                                ForEach(messages) { message in
                                    ChatBubbleView(
                                        message: message,
                                        onSave: message.story != nil ? onSave : nil,
                                        onShare: message.story != nil ? onShare : nil,
                                        onToggleFavorite: message.story != nil ? onToggleFavorite : nil,
                                        onQuickAction: { action in
                                            // Fill input with quick action text
                                            inputMessage = action
                                        }
                                    )
                                    .id(message.id)
                                }
                                
                                // Loading indicator
                                if isLoading {
                                    HStack(alignment: .top, spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .fill(themeManager.current.accentGradient)
                                                .frame(width: 32, height: 32)
                                            Image(systemName: "sparkles")
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(.white)
                                        }
                                        
                                        HStack(spacing: 4) {
                                            ForEach(0..<3) { index in
                                                Circle()
                                                    .fill(Color.secondary.opacity(0.6))
                                                    .frame(width: 8, height: 8)
                                                    .scaleEffect(1.0)
                                                    .opacity(1.0)
                                                    .modifier(PulsingDotAnimation(delay: Double(index) * 0.2))
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(20, corners: [.topLeft, .topRight, .bottomRight])
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .id("loading")
                                }
                                
                                // Error message
                                if !error.isEmpty {
                                    HStack {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundColor(.red)
                                        Text(error)
                                            .font(AppTheme.roundedFont(.subheadline))
                                            .foregroundColor(.red)
                                    }
                                    .padding()
                                    .background(Color.red.opacity(0.1))
                                    .cornerRadius(12)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                }
                                
                                // Bottom padding - dynamically calculated based on keyboard and input state
                                Spacer()
                                    .frame(height: calculateBottomPadding(geometry: geometry))
                                    .id("bottom-spacer")
                            }
                        }
                        .scrollIndicators(.hidden)
                        .onAppear {
                            scrollProxy = proxy
                        }
                        .onChange(of: messages.count) { _ in
                            if let lastMessage = messages.last {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                    }
                                }
                            }
                        }
                        .onChange(of: isLoading) { loading in
                            if loading {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        proxy.scrollTo("loading", anchor: .bottom)
                                    }
                                }
                            } else {
                                // When loading finishes, scroll to last message
                                if let lastMessage = messages.last {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        withAnimation(.easeOut(duration: 0.3)) {
                                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                        }
                                    }
                                }
                            }
                        }
                        .dismissKeyboardOnTap()
                    }
                    
                    // Chat input - overlaid at bottom
                    VStack {
                        Spacer()
                        ChatInputView(
                            message: $inputMessage,
                            onSubmit: {
                                handleSubmit()
                            },
                            isLoading: isLoading,
                            hasCurrentStory: currentStory != nil,
                            onNewStory: !messages.isEmpty ? onClearChat : nil
                        )
                        .background(
                            Color(.systemBackground)
                                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: -5)
                        )
                    }
                }
            }
            .dismissKeyboardOnDrag()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
                // Scroll to show content when keyboard appears
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    guard let proxy = scrollProxy else { return }
                    // Use Task to ensure we're on the main actor
                    Task { @MainActor in
                        withAnimation(.easeOut(duration: 0.3)) {
                            if let lastMessage = messages.last {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            } else {
                                proxy.scrollTo("bottom-spacer", anchor: .bottom)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var welcomeMessage: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(themeManager.current.accentGradient)
                    .frame(width: 80, height: 80)
                Image(systemName: "sparkles")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 8) {
                Text("chat.welcome.title".localized)
                    .font(AppTheme.roundedFont(.title2, weight: .bold))
                    .multilineTextAlignment(.center)
                
                Text("chat.welcome.subtitle".localized)
                    .font(AppTheme.roundedFont(.subheadline))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(32)
    }
    
    private func calculateBottomPadding(geometry: GeometryProxy) -> CGFloat {
        // Input view components:
        // - Input field row: ~60px (text field + send button + padding)
        // - Quick settings bar (when visible and input empty): ~40px
        // - VStack padding: ~24px (12px top + 12px bottom)
        // - Hint text (when visible): ~20px
        
        let inputFieldHeight: CGFloat = 60
        let quickSettingsHeight: CGFloat = (inputMessage.isEmpty && !keyboardManager.isVisible) ? 40 : 0
        let hintTextHeight: CGFloat = (inputMessage.isEmpty && !keyboardManager.isVisible && currentStory == nil) ? 20 : 0
        let vStackPadding: CGFloat = 24
        
        let inputViewHeight = inputFieldHeight + quickSettingsHeight + hintTextHeight + vStackPadding
        let safeAreaBottom = geometry.safeAreaInsets.bottom
        
        if keyboardManager.isVisible {
            // When keyboard is visible, input view is above keyboard
            // We need padding for keyboard height + safe area
            return keyboardManager.height + safeAreaBottom
        } else {
            // When keyboard is hidden, we need padding for input view + safe area
            return inputViewHeight + safeAreaBottom
        }
    }
    
    private func handleSubmit() {
        let userMessage = inputMessage.trimmingCharacters(in: .whitespaces)
        guard !userMessage.isEmpty else { return }
        
        // Add user message to chat
        let userChatMessage = ChatMessage(
            role: .user,
            content: userMessage
        )
        messages.append(userChatMessage)
        
        // Update form values
        formValues.brief = userMessage
        inputMessage = ""
        
        // Submit
        onSubmit()
    }
}

// Animation modifier for pulsing dots
struct PulsingDotAnimation: ViewModifier {
    let delay: Double
    @State private var isAnimating = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isAnimating ? 1.3 : 0.8)
            .opacity(isAnimating ? 1.0 : 0.5)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: 0.6)
                        .repeatForever(autoreverses: true)
                        .delay(delay)
                ) {
                    isAnimating = true
                }
            }
    }
}

#Preview {
    GenerateStoryView(
        keyboardManager: KeyboardManager(),
        formValues: .constant(StoryFormValues()),
        isLoading: .constant(false),
        error: .constant(""),
        currentStory: .constant(nil),
        messages: .constant([]),
        onSubmit: {},
        onSave: {},
        onShare: {},
        onToggleFavorite: nil,
        onClearChat: {}
    )
    .environmentObject(ThemeManager())
}
