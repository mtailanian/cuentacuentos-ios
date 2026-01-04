import SwiftUI

struct SavedStoriesView: View {
    @ObservedObject var localizationManager: LocalizationManager = .shared
    @EnvironmentObject var themeManager: ThemeManager
    
    @Binding var savedStories: [Story]
    let onDelete: (String) -> Void
    let onSelect: (Story) -> Void
    
    @State private var navigationPath: [Story] = []
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                if savedStories.isEmpty {
                    emptyState
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                } else {
                    ForEach(savedStories) { story in
                        NavigationLink(value: story) {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(AppTheme.Colors.secondary.opacity(0.18))
                                            .frame(width: 42, height: 42)
                                        Image(systemName: "book.fill")
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundColor(AppTheme.Colors.secondary)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(story.title)
                                            .font(AppTheme.roundedFont(.headline, weight: .semibold))
                                            .foregroundColor(.primary)
                                            .lineLimit(1)
                                        Text("\("story.for".localized) \(story.name) · \("story.age".localized) \(story.age) · \(story.language.displayName)")
                                            .font(AppTheme.roundedFont(.caption))
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                    }
                                    Spacer()
                                }
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(AppTheme.Colors.surface)
                            .cornerRadius(AppTheme.Radii.large)
                            .shadow(color: AppTheme.Colors.subtleShadow, radius: 6, x: 0, y: 3)
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .swipeActions {
                            Button(role: .destructive) {
                                onDelete(story.id)
                            } label: {
                                Label("saved.delete".localized, systemImage: "trash")
                            }
                            .tint(AppTheme.Colors.secondary)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .background(ThemeBackgroundView(theme: themeManager.current))
            .navigationTitle("tab.saved".localized)
            .navigationDestination(for: Story.self) { story in
                StoryDetailView(
                    story: story
                )
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(AppTheme.Colors.primary.opacity(0.15))
                    .frame(width: 84, height: 84)
                Image(systemName: "sparkles")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(AppTheme.Colors.primary)
            }
            Text("saved.stories".localized)
                .font(AppTheme.roundedFont(.title3, weight: .semibold))
            Text("saved.stories.empty".localized)
                .font(AppTheme.roundedFont(.subheadline))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

