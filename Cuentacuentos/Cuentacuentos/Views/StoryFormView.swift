import SwiftUI

struct StoryFormView: View {
    @Binding var formValues: StoryFormValues
    let onSubmit: () -> Void
    let isLoading: Bool
    @StateObject private var localizationManager = LocalizationManager.shared
    
    @State private var error: String = ""
    @State private var ageValue: Int = 6
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 18) {
                ideaSection
                ageSection
                lengthSection
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
            
            if !error.isEmpty {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
            }
            
                Button(action: {
                    validateAndSubmit()
                }) {
                    HStack {
                        Spacer()
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                        Text("form.generate".localized)
                                .fontWeight(.semibold)
                        }
                        Spacer()
                    }
                .padding()
            }
            .buttonStyle(.borderedProminent)
            .disabled(isLoading)
        }
        .onAppear {
            if let existingAge = Int(formValues.age), existingAge >= 1, existingAge <= 15 {
                ageValue = existingAge
            } else {
                formValues.age = "\(ageValue)"
            }
        }
        .onChange(of: ageValue) { newValue in
            formValues.age = "\(newValue)"
        }
    }
    
    @ViewBuilder
    private var ideaSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("form.story.idea".localized)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                HStack(spacing: 8) {
                    Text("form.random.topic".localized)
                        .font(.caption)
                        .padding(.leading, 4)
                    Toggle("", isOn: $formValues.randomTopic)
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: AppTheme.Colors.secondary))
                }
            }
            
            TextEditor(text: $formValues.brief)
                .frame(height: 110)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(AppTheme.Colors.secondary.opacity(0.3), lineWidth: 1)
                )
                .disabled(formValues.randomTopic)
                .opacity(formValues.randomTopic ? 0.5 : 1.0)
            
            Text("form.story.idea.hint".localized)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    @ViewBuilder
    private var ageSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("form.age.target".localized)
                .font(AppTheme.roundedFont(.subheadline, weight: .semibold))
            HStack(spacing: 12) {
                Text("\(ageValue)")
                    .font(AppTheme.roundedFont(.title2, weight: .bold))
                Stepper("", value: $ageValue, in: 1...15, step: 1)
                    .labelsHidden()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(.systemGray6))
            .cornerRadius(AppTheme.Radii.large)
        }
    }
    
    @ViewBuilder
    private var lengthSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("form.length".localized)
                .font(AppTheme.roundedFont(.subheadline, weight: .semibold))
            HStack(spacing: 10) {
                ForEach(StoryFormValues.StoryLength.allCases, id: \.self) { length in
                    Button {
                        formValues.length = length
                    } label: {
                        Text(length.displayName)
                            .font(AppTheme.roundedFont(.caption, weight: .semibold))
                            .foregroundColor(formValues.length == length ? .white : .primary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                                    .background(
                                        formValues.length == length
                                        ? AnyShapeStyle(AppGradients.chipActive)
                                        : AnyShapeStyle(Color(.systemGray6))
                                    )
                            .cornerRadius(AppTheme.Radii.medium)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private func validateAndSubmit() {
        error = ""

        guard let age = Int(formValues.age), age > 0, age <= 15 else {
            error = "form.age.invalid".localized
            return
        }
        
        onSubmit()
    }
}

#Preview {
    StoryFormView(
        formValues: .constant(StoryFormValues()),
        onSubmit: {},
        isLoading: false
    )
}

