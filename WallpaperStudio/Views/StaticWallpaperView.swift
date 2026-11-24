import SwiftUI

struct StaticWallpaperView: UIViewRepresentable {
    let preset: WallpaperPreset
    let settings: RenderSettings

    func makeUIView(context: Context) -> UIImageView {
        let size = CGSize(width: 360, height: 640)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            WallpaperRenderer.render(preset: preset,
                                     settings: settings,
                                     time: 0,
                                     motion: .zero,
                                     in: ctx.cgContext,
                                     size: size)
        }

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .black
        return imageView
    }

    func updateUIView(_ imageView: UIImageView, context: Context) {
        let size = CGSize(width: 360, height: 640)
        let renderer = UIGraphicsImageRenderer(size: size)
        imageView.image = renderer.image { ctx in
            WallpaperRenderer.render(preset: preset,
                                     settings: settings,
                                     time: 0,
                                     motion: .zero,
                                     in: ctx.cgContext,
                                     size: size)
        }
    }
}
