import SwiftUI
import Combine

class KeyboardManager: ObservableObject {
    @Published var isVisible: Bool = false
    @Published var height: CGFloat = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { [weak self] notification in
                guard let self = self,
                      let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
                      let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let window = windowScene.windows.first else {
                    return
                }
                
                // Calculate keyboard height relative to window, accounting for safe area
                let safeAreaBottom = window.safeAreaInsets.bottom
                let keyboardHeight = window.bounds.height - keyboardFrame.origin.y - safeAreaBottom
                
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.height = max(0, keyboardHeight)
                    self.isVisible = true
                }
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] _ in
                guard let self = self else { return }
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.height = 0
                    self.isVisible = false
                }
            }
            .store(in: &cancellables)
    }
}

