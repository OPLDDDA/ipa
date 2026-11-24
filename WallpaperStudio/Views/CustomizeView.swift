import SwiftUI

struct CustomizeView: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        NavigationStack {
            Form {
                Section("Движение") {
                    Slider(value: $state.settings.motion, in: 0...2, step: 0.05) {
                        Text("Parallax")
                    }
                    Text("\(state.settings.motion, specifier: "%.2f")×")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Slider(value: $state.settings.speed, in: 0.2...3, step: 0.05) {
                        Text("Скорость анимации")
                    }
                    Text("\(state.settings.speed, specifier: "%.2f")×")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section("Картинка") {
                    Slider(value: $state.settings.softness, in: 0...1, step: 0.02) {
                        Text("Мягкость")
                    }
                    Slider(value: $state.settings.grain, in: 0...0.35, step: 0.01) {
                        Text("Зерно")
                    }
                    Slider(value: $state.settings.glow, in: 0.2...1.8, step: 0.05) {
                        Text("Свечение")
                    }
                }

                Section {
                    Button("Сбросить настройки") { state.reset() }
                }

                Section("Пресет") {
                    Picker("Активные обои", selection: $state.selectedID) {
                        ForEach(WallpaperPreset.all) { preset in
                            Text(preset.name).tag(preset.id)
                        }
                    }
                }
            }
            .navigationTitle("Кастом")
        }
    }
}
