import Foundation

enum FeedReducer {
    static func reduce(_ state: FeedState, _ action: FeedAction) -> FeedState {
        var next = state
        next.errorMessage = nil

        switch action {
        case .loadRequested:
            next.isLoading = true
        case .loadSucceeded(let posts, let source):
            next.isLoading = false
            next.posts = posts
            next.source = source
        case .loadFailed(let message):
            next.isLoading = false
            next.errorMessage = message
        case .toggleFavorite:
            break
        case .favoritesUpdated(let ids):
            next.favoriteIDs = ids
        case .toggleFavoritesFilter:
            next.showsFavoritesOnly.toggle()
        }

        return next
    }
}
