import SwiftUI

struct ContentView: View {
    @StateObject private var store = FeedStore()

    var body: some View {
        NavigationStack {
            FeedView(store: store)
        }
    }
}

#Preview {
    let _ = AppAssembly.bootstrapPreview()
    ContentView()
}
