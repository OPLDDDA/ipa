import SwiftUI

struct GalleryView: View {
    @EnvironmentObject private var state: AppState
    private let columns = [GridItem(.flexible(), spacing: 12),
                           GridItem(.flexible(), spacing: 12)]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 18) {
                    ForEach(WallpaperPreset.all) { preset in
                        NavigationLink(value: preset.id) {
                            VStack(alignment: .leading, spacing: 6) {
                                StaticWallpaperView(preset: preset, settings: state.settings)
                                    .frame(height: 210)
                                    .clipShape(RoundedRectangle(cornerRadius: 18))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 18)
                                            .stroke(.white.opacity(0.12), lineWidth: 1)
                                    )

                                Text(preset.name)
                                    .font(.headline)
                                    .foregroundStyle(.primary)

                                Text(preset.subtitle)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .navigationTitle("Живые обои")
            .navigationDestination(for: String.self) { id in
                if let preset = WallpaperPreset.all.first(where: { $0.id == id }) {
                    WallpaperDetailView(preset: preset)
                }
            }
        }
    }
}
