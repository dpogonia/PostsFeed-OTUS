import SwiftUI

struct FeedView: View {
    @ObservedObject var store: FeedStore

    var body: some View {
        List {
            if let source = store.state.source {
                Section {
                    Label(
                        source == .cache ? "Показан кэш" : "Данные с сервера",
                        systemImage: source == .cache ? "externaldrive" : "wifi"
                    )
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .listRowBackground(Color.clear)
                }
            }

            if let errorMessage = store.state.errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }

            Section {
                ForEach(store.state.visiblePosts) { post in
                    PostRowView(
                        post: post,
                        isFavorite: store.state.favoriteIDs.contains(post.id)
                    ) {
                        store.send(.toggleFavorite(post.id))
                    }
                }
            }
        }
        .overlay {
            if store.state.isLoading && store.state.posts.isEmpty {
                ProgressView("Загрузка постов…")
            } else if store.state.visiblePosts.isEmpty && !store.state.isLoading {
                ContentUnavailableView(
                    store.state.showsFavoritesOnly ? "Нет избранного" : "Нет постов",
                    systemImage: store.state.showsFavoritesOnly ? "heart" : "doc.text",
                    description: Text(store.state.showsFavoritesOnly
                        ? "Отметьте посты сердечком — они появятся здесь."
                        : "Потяните список вниз или нажмите обновление.")
                )
            }
        }
        .navigationTitle("Лента")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    store.send(.toggleFavoritesFilter)
                } label: {
                    Image(systemName: store.state.showsFavoritesOnly ? "heart.fill" : "heart")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    store.send(.loadRequested)
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .disabled(store.state.isLoading)
            }
        }
        .refreshable {
            store.send(.loadRequested)
            while store.state.isLoading {
                try? await Task.sleep(for: .milliseconds(50))
            }
        }
        .onAppear {
            if store.state.posts.isEmpty {
                store.send(.loadRequested)
            }
        }
    }
}

private struct PostRowView: View {
    let post: Post
    let isFavorite: Bool
    let onToggleFavorite: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(post.title)
                    .font(.headline)
                    .textCase(.none)
                Text(post.body)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
            }
            Spacer(minLength: 8)
            Button(action: onToggleFavorite) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundStyle(isFavorite ? .red : .secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}
