import SwiftUI
import Photos

struct WallpaperDetailView: View {
    let preset: WallpaperPreset
    @EnvironmentObject private var state: AppState
    @State private var exporting = false
    @State private var alertText = ""
    @State private var showAlert = false

    var body: some View {
        ZStack(alignment: .bottom) {
            AnimatedWallpaperView(preset: preset, settings: state.settings)
                .ignoresSafeArea()

            VStack(spacing: 12) {
                Text(preset.name)
                    .font(.largeTitle.bold())
                    .shadow(radius: 10)

                Text("Parallax · 1080×1920 · H.264")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.8))

                Button {
                    Task { await saveToPhotos() }
                } label: {
                    if exporting {
                        HStack(spacing: 8) {
                            ProgressView().tint(.white)
                            Text("Рендерю видео…")
                        }
                    } else {
                        Label("Сохранить в Фото", systemImage: "square.and.arrow.down")
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(exporting)
            }
            .padding(18)
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22))
            .padding()
        }
        .navigationTitle(preset.name)
        .navigationBarTitleDisplayMode(.inline)
        .alert(alertText, isPresented: $showAlert) {
            Button("Ок", role: .cancel) { }
        }
    }

    private func saveToPhotos() async {
        exporting = true
        defer { exporting = false }

        do {
            let url = try await VideoExporter().export(preset: preset, settings: state.settings)
            try await PHPhotoLibrary.shared().performChanges {
                _ = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
            }
            alertText = "Готово. Видео лежит в Фото — открой его, «Поделиться» → «Использовать как обои»."
        } catch {
            alertText = "Ошибка экспорта: \(error.localizedDescription)"
        }
        showAlert = true
    }
}
