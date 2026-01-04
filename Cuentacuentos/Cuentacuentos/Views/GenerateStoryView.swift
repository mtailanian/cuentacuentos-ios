import SwiftUI

struct GenerateStoryView: View {
    @ObservedObject var localizationManager: LocalizationManager = .shared
    @EnvironmentObject var themeManager: ThemeManager
    
    @Binding var formValues: StoryFormValues
    @Binding var isLoading: Bool
    @Binding var error: String
    @Binding var currentStory: Story?
    
    let onSubmit: () -> Void
    let onSave: () -> Void
    let onShare: () -> Void
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    headerCard
                    
                    VStack(spacing: 14) {
                        StoryFormView(
                            formValues: $formValues,
                            onSubmit: onSubmit,
                            isLoading: isLoading
                        )
                        
                        if !error.isEmpty {
                            Text(error)
                                .font(AppTheme.roundedFont(.caption, weight: .semibold))
                                .foregroundColor(.red)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(AppTheme.Radii.medium)
                        }
                        
                        if let story = currentStory {
                            StoryDisplayView(
                                story: story,
                                onSave: onSave,
                                onShare: onShare
                            )
                        }
                    }
                }
                .padding()
            }
            .background(ThemeBackgroundView(theme: themeManager.current))
        }
    }
    
    private var headerCard: some View {
        HStack(alignment: .center, spacing: 14) {
            ZStack {
                Circle()
                    .fill(themeManager.current.accentGradient)
                    .frame(width: 60, height: 60)
                    .shadow(color: AppTheme.Colors.subtleShadow, radius: 10, x: 0, y: 6)
                Image(systemName: "sparkles")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(.white)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("generate.title".localized)
                    .font(AppTheme.roundedFont(.title2, weight: .bold))
                    .foregroundColor(.primary)
            }
            Spacer()
        }
        .padding()
        .background(AppTheme.Colors.surface)
        .cornerRadius(AppTheme.Radii.large)
        .shadow(color: AppTheme.Colors.subtleShadow, radius: 12, x: 0, y: 8)
    }
}

