import SwiftUI

struct StoryDisplayView: View {
    let story: Story
    let onSave: () -> Void
    let onShare: () -> Void
    @StateObject private var localizationManager = LocalizationManager.shared
    @State private var playbackVoice: Story.Voice = .auto
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("story.your.story".localized)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .textCase(.uppercase)
                        .tracking(0.5)
                    
                    Text(story.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("\("story.for".localized) \(story.name) · \("story.age".localized) \(story.age) · \(story.language.displayName)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(spacing: 8) {
                    Button(action: onShare) {
                        Text("story.share".localized)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.bordered)
                    
                    Button(action: onSave) {
                        Text("story.save".localized)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(story.content.components(separatedBy: "\n").filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }, id: \.self) { paragraph in
                        Text(paragraph.trimmingCharacters(in: .whitespaces))
                            .font(.body)
                            .lineSpacing(4)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("story.playback.voice".localized)
                    .font(.caption)
                    .fontWeight(.medium)
                
                Picker("story.playback.voice".localized, selection: $playbackVoice) {
                    ForEach(Story.Voice.allCases, id: \.self) { voice in
                        Text(voice.displayName).tag(voice)
                    }
                }
                .pickerStyle(.menu)
                
                Text("story.voice.hint".localized)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                AudioPlayerView(
                    text: story.content,
                    language: story.language,
                    voice: playbackVoice == .auto ? nil : playbackVoice
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .onAppear {
            playbackVoice = story.voice ?? .auto
        }
    }
}

#Preview {
    StoryDisplayView(
        story: Story(
            id: "1",
            title: "The Magic Forest",
            content: "Once upon a time, there was a little girl named Sofia who loved to explore.\n\nShe found a magical forest where all the animals could talk.",
            createdAt: ISO8601DateFormatter().string(from: Date()),
            name: "Sofia",
            age: 6,
            language: .spanish,
            voice: nil,
            randomTopic: false,
            brief: nil
        ),
        onSave: {},
        onShare: {}
    )
    .padding()
}

