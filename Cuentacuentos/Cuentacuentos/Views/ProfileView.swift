import SwiftUI
import PhotosUI

struct ProfileView: View {
    @ObservedObject var localizationManager: LocalizationManager = .shared
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var userName: String = "Alex"
    @State private var credits: Int = 5
    @State private var notificationsEnabled: Bool = true
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: UIImage?
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 16) {
                        PhotosPicker(selection: $avatarItem, matching: .images, photoLibrary: .shared()) {
                            ZStack {
                                if let image = avatarImage {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 72, height: 72)
                                        .clipShape(Circle())
                                        .overlay(
                                            Circle()
                                                .stroke(AppGradients.accent, lineWidth: 3)
                                        )
                                } else {
                                    Circle()
                                        .fill(AppTheme.Colors.primary.opacity(0.15))
                                        .frame(width: 72, height: 72)
                                        .overlay(
                                            Image(systemName: "person.crop.circle")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(AppTheme.Colors.primary)
                                                .padding(12)
                                        )
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("profile.user.section".localized)
                                .font(AppTheme.roundedFont(.headline, weight: .semibold))
                            TextField("profile.name.placeholder".localized, text: $userName)
                                .textFieldStyle(.roundedBorder)
                                .textInputAutocapitalization(.words)
                                .disableAutocorrection(true)
                            Text("profile.photo.placeholder".localized)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .listRowBackground(AppTheme.Colors.surface)
                
                Section {
                    HStack {
                        Text("profile.language.section".localized)
                        Spacer()
                        Picker("", selection: $localizationManager.currentLanguage) {
                            ForEach(Story.Language.allCases, id: \.self) { lang in
                                Text(lang.displayName).tag(lang)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(.menu)
                    }
                }
                .listRowBackground(AppTheme.Colors.surface)
                
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("profile.credits.section".localized)
                                .font(AppTheme.roundedFont(.headline, weight: .semibold))
                            Spacer()
                            Text("\(credits)")
                                .font(AppTheme.roundedFont(.title3, weight: .bold))
                                .foregroundColor(AppTheme.Colors.accent)
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Label("profile.credits.add".localized, systemImage: "plus.circle")
                                .foregroundColor(.secondary)
                            Label("profile.payment.card".localized, systemImage: "creditcard")
                                .foregroundColor(.secondary)
                            Label("profile.payment.iap".localized, systemImage: "cart")
                                .foregroundColor(.secondary)
                        }
                        .font(AppTheme.roundedFont(.subheadline))
                    }
                }
                .listRowBackground(AppTheme.Colors.surface)
                
                Section {
                    Toggle("profile.notifications".localized, isOn: $notificationsEnabled)
                }
                .listRowBackground(AppTheme.Colors.surface)
                
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("theme.select".localized)
                            .font(AppTheme.roundedFont(.headline, weight: .semibold))
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(ThemeVariant.allCases) { theme in
                                    Button {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            themeManager.current = theme
                                        }
                                    } label: {
                                        VStack(alignment: .leading, spacing: 6) {
                                            RoundedRectangle(cornerRadius: AppTheme.Radii.medium)
                                                .fill(theme.accentGradient)
                                                .frame(width: 90, height: 50)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: AppTheme.Radii.medium)
                                                        .stroke(themeManager.current == theme ? Color.white.opacity(0.8) : Color.clear, lineWidth: 2)
                                                )
                                                .shadow(color: AppTheme.Colors.subtleShadow, radius: 4, x: 0, y: 2)
                                            
                                            Text(theme.displayNameKey.localized)
                                                .font(AppTheme.roundedFont(.caption, weight: .semibold))
                                                .foregroundColor(.primary)
                                                .lineLimit(1)
                                        }
                                        .padding(10)
                                        .background(themeManager.current == theme ? Color.white.opacity(0.25) : Color.white.opacity(0.12))
                                        .cornerRadius(AppTheme.Radii.large)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .listRowBackground(AppTheme.Colors.surface.opacity(0.6))
            }
            .listStyle(.insetGrouped)
            .navigationTitle("tab.profile".localized)
            .scrollContentBackground(.hidden)
            .background(ThemeBackgroundView(theme: themeManager.current))
        }
        .onChange(of: avatarItem) { newItem in
            guard let item = newItem else { return }
            Task {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    await MainActor.run {
                        self.avatarImage = image
                    }
                }
            }
        }
    }
}

