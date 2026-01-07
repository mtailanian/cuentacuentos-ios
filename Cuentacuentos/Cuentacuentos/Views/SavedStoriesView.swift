import SwiftUI

struct SavedStoriesView: View {
    @ObservedObject var localizationManager: LocalizationManager = .shared
    @EnvironmentObject var themeManager: ThemeManager
    
    @Binding var savedStories: [Story]
    let onDelete: (String) -> Void
    let onToggleFavorite: (String) -> Void
    let onRefresh: () -> Void
    
    @State private var navigationPath: [Story] = []
    @State private var searchText: String = ""
    @State private var showFavoritesOnly: Bool = false
    
    private var filteredStories: [Story] {
        var stories = savedStories
        
        // Filter by favorites
        if showFavoritesOnly {
            stories = stories.filter { $0.isFavorite }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            stories = stories.filter { story in
                story.title.localizedCaseInsensitiveContains(searchText) ||
                story.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return stories
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 0) {
                // Search bar and filter
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)
                            TextField("saved.search.placeholder".localized, text: $searchText)
                                .textFieldStyle(.plain)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(AppTheme.Colors.surface)
                        .cornerRadius(AppTheme.Radii.medium)
                        
                        Button {
                            HapticManager.selection()
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                showFavoritesOnly.toggle()
                            }
                        } label: {
                            Image(systemName: showFavoritesOnly ? "heart.fill" : "heart")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(showFavoritesOnly ? .red : .secondary)
                                .frame(width: 44, height: 44)
                                .background(AppTheme.Colors.surface)
                                .cornerRadius(AppTheme.Radii.medium)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
                
            List {
                    if filteredStories.isEmpty {
                    emptyState
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                } else {
                        ForEach(filteredStories) { story in
                            Button {
                                navigationPath.append(story)
                            } label: {
                                storyRow(story)
                            }
                            .buttonStyle(.plain)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    HapticManager.impact(style: .medium)
                                    onDelete(story.id)
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .tint(.red)
                                
                                Button {
                                    HapticManager.notification(type: story.isFavorite ? .warning : .success)
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        onToggleFavorite(story.id)
                                    }
                                } label: {
                                    Image(systemName: story.isFavorite ? "heart.slash.fill" : "heart.fill")
                                }
                                .tint(.pink)
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
            }
            .background(ThemeBackgroundView(theme: themeManager.current))
            .navigationTitle("tab.saved".localized)
            .navigationDestination(for: Story.self) { story in
                StoryDetailView(
                    story: story,
                    onToggleFavorite: {
                        onToggleFavorite(story.id)
                    }
                )
            }
            .refreshable {
                HapticManager.impact(style: .light)
                onRefresh()
            }
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 20)
                .onEnded { value in
                    // Dismiss keyboard on drag down (swipe down gesture)
                    if value.translation.height > 100 {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
        )
    }
    
    private func storyRow(_ story: Story) -> some View {
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
                HStack(spacing: 6) {
                                        Text(story.title)
                                            .font(AppTheme.roundedFont(.headline, weight: .semibold))
                                            .foregroundColor(.primary)
                                            .lineLimit(1)
                    
                    if story.isFavorite {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.red)
                    }
                }
                                        Text(story.formattedMetadata)
                                            .font(AppTheme.roundedFont(.caption))
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                    }
            
                                    Spacer()
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(AppTheme.Colors.surface)
                            .cornerRadius(AppTheme.Radii.large)
                            .shadow(color: AppTheme.Colors.subtleShadow, radius: 6, x: 0, y: 3)
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(AppTheme.Colors.primary.opacity(0.15))
                    .frame(width: 84, height: 84)
                Image(systemName: searchText.isEmpty && !showFavoritesOnly ? "sparkles" : "magnifyingglass")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(AppTheme.Colors.primary)
            }
            Text(searchText.isEmpty && !showFavoritesOnly ? "saved.stories".localized : "saved.no.results".localized)
                .font(AppTheme.roundedFont(.title3, weight: .semibold))
            Text(searchText.isEmpty && !showFavoritesOnly ? "saved.stories.empty".localized : "saved.no.results.hint".localized)
                .font(AppTheme.roundedFont(.subheadline))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(minHeight: 200)
    }
}

