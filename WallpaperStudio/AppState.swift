import Foundation

struct RenderSettings: Codable, Hashable {
    var motion: Double = 1.0
    var speed: Double = 1.0
    var softness: Double = 0.0
    var grain: Double = 0.12
    var glow: Double = 1.0

    static let `default` = RenderSettings()
}

final class AppState: ObservableObject {
    @Published var settings: RenderSettings {
        didSet { persist() }
    }
    @Published var selectedID: String {
        didSet { UserDefaults.standard.set(selectedID, forKey: "selectedID") }
    }

    private let defaults = UserDefaults.standard

    init() {
        if let data = defaults.data(forKey: "renderSettings"),
           let decoded = try? JSONDecoder().decode(RenderSettings.self, from: data) {
            settings = decoded
        } else {
            settings = .default
        }
        selectedID = defaults.string(forKey: "selectedID") ?? WallpaperPreset.all[0].id
    }

    func reset() {
        settings = .default
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(settings) else { return }
        defaults.set(data, forKey: "renderSettings")
    }
}
