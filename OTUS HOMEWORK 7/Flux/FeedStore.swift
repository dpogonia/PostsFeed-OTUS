import Combine
import CoreServices
import Foundation

@MainActor
final class FeedStore: ObservableObject {
    private let postsService: any PostsServing
    private let favoritesService: any FavoritesServing

    @Published private(set) var state: FeedState

    init(
        postsService: any PostsServing = ServiceLocator.shared.resolve(),
        favoritesService: any FavoritesServing = ServiceLocator.shared.resolve()
    ) {
        self.postsService = postsService
        self.favoritesService = favoritesService
        var state = FeedState()
        state.favoriteIDs = favoritesService.loadIDs()
        self.state = state
    }

    func send(_ action: FeedAction) {
        state = FeedReducer.reduce(state, action)

        switch action {
        case .loadRequested:
            Task { await loadPosts() }
        case .toggleFavorite(let id):
            let ids = favoritesService.toggle(id)
            send(.favoritesUpdated(ids))
        default:
            break
        }
    }

    private func loadPosts() async {
        do {
            let result = try await postsService.fetchPosts()
            send(.loadSucceeded(posts: result.posts, source: result.source))
        } catch {
            send(.loadFailed(error.localizedDescription))
        }
    }
}
