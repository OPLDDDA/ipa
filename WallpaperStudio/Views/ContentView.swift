import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            GalleryView()
                .tabItem { Label("Обои", systemImage: "photo.stack") }
            CustomizeView()
                .tabItem { Label("Кастом", systemImage: "slider.horizontal.3") }
            AboutView()
                .tabItem { Label("Инфо", systemImage: "info.circle") }
        }
        .tint(.pink)
    }
}
