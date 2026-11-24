import UIKit

struct WallpaperBlob: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var radius: CGFloat
    var color: UIColor
    var speed: Double
}

struct WallpaperPreset: Identifiable {
    let id: String
    let name: String
    let subtitle: String
    let background: UIColor
    let blobs: [WallpaperBlob]

    static let all: [WallpaperPreset] = [
        WallpaperPreset(
            id: "aurora",
            name: "Aurora",
            subtitle: "Северное сияние",
            background: UIColor(red: 0.03, green: 0.04, blue: 0.12, alpha: 1),
            blobs: [
                WallpaperBlob(x: 0.20, y: 0.22, radius: 0.62, color: UIColor(red: 0.10, green: 0.95, blue: 0.72, alpha: 1), speed: 0.34),
                WallpaperBlob(x: 0.80, y: 0.38, radius: 0.55, color: UIColor(red: 0.24, green: 0.42, blue: 1.00, alpha: 1), speed: 0.27),
                WallpaperBlob(x: 0.42, y: 0.82, radius: 0.70, color: UIColor(red: 0.72, green: 0.20, blue: 0.95, alpha: 1), speed: 0.41)
            ]
        ),
        WallpaperPreset(
            id: "ember",
            name: "Ember",
            subtitle: "Тлеющие угли",
            background: UIColor(red: 0.10, green: 0.02, blue: 0.02, alpha: 1),
            blobs: [
                WallpaperBlob(x: 0.30, y: 0.70, radius: 0.75, color: UIColor(red: 1.00, green: 0.28, blue: 0.05, alpha: 1), speed: 0.38),
                WallpaperBlob(x: 0.72, y: 0.45, radius: 0.60, color: UIColor(red: 1.00, green: 0.72, blue: 0.10, alpha: 1), speed: 0.29),
                WallpaperBlob(x: 0.18, y: 0.20, radius: 0.48, color: UIColor(red: 0.85, green: 0.08, blue: 0.22, alpha: 1), speed: 0.45)
            ]
        ),
        WallpaperPreset(
            id: "lagoon",
            name: "Lagoon",
            subtitle: "Глубокая лагуна",
            background: UIColor(red: 0.01, green: 0.08, blue: 0.13, alpha: 1),
            blobs: [
                WallpaperBlob(x: 0.24, y: 0.30, radius: 0.70, color: UIColor(red: 0.00, green: 0.85, blue: 0.92, alpha: 1), speed: 0.31),
                WallpaperBlob(x: 0.78, y: 0.68, radius: 0.66, color: UIColor(red: 0.08, green: 0.45, blue: 1.00, alpha: 1), speed: 0.36),
                WallpaperBlob(x: 0.50, y: 0.12, radius: 0.50, color: UIColor(red: 0.20, green: 1.00, blue: 0.62, alpha: 1), speed: 0.24)
            ]
        ),
        WallpaperPreset(
            id: "neon-dusk",
            name: "Neon Dusk",
            subtitle: "Неоновый закат",
            background: UIColor(red: 0.07, green: 0.02, blue: 0.14, alpha: 1),
            blobs: [
                WallpaperBlob(x: 0.70, y: 0.24, radius: 0.68, color: UIColor(red: 1.00, green: 0.18, blue: 0.62, alpha: 1), speed: 0.33),
                WallpaperBlob(x: 0.26, y: 0.52, radius: 0.62, color: UIColor(red: 0.62, green: 0.22, blue: 1.00, alpha: 1), speed: 0.42),
                WallpaperBlob(x: 0.58, y: 0.86, radius: 0.58, color: UIColor(red: 1.00, green: 0.46, blue: 0.18, alpha: 1), speed: 0.26)
            ]
        ),
        WallpaperPreset(
            id: "bubblegum",
            name: "Bubblegum",
            subtitle: "Жвачка и сахар",
            background: UIColor(red: 0.16, green: 0.05, blue: 0.18, alpha: 1),
            blobs: [
                WallpaperBlob(x: 0.32, y: 0.28, radius: 0.66, color: UIColor(red: 1.00, green: 0.48, blue: 0.78, alpha: 1), speed: 0.30),
                WallpaperBlob(x: 0.74, y: 0.62, radius: 0.64, color: UIColor(red: 0.98, green: 0.82, blue: 0.42, alpha: 1), speed: 0.39),
                WallpaperBlob(x: 0.18, y: 0.84, radius: 0.52, color: UIColor(red: 0.58, green: 0.62, blue: 1.00, alpha: 1), speed: 0.23)
            ]
        ),
        WallpaperPreset(
            id: "deep-space",
            name: "Deep Space",
            subtitle: "Холодный космос",
            background: UIColor(red: 0.01, green: 0.01, blue: 0.04, alpha: 1),
            blobs: [
                WallpaperBlob(x: 0.22, y: 0.18, radius: 0.58, color: UIColor(red: 0.28, green: 0.48, blue: 1.00, alpha: 1), speed: 0.22),
                WallpaperBlob(x: 0.82, y: 0.50, radius: 0.54, color: UIColor(red: 0.70, green: 0.30, blue: 1.00, alpha: 1), speed: 0.28),
                WallpaperBlob(x: 0.46, y: 0.88, radius: 0.62, color: UIColor(red: 0.10, green: 0.78, blue: 0.94, alpha: 1), speed: 0.19)
            ]
        )
    ]
}
