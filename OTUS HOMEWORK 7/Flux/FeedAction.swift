import Foundation

enum FeedAction: Equatable {
    case loadRequested
    case loadSucceeded(posts: [Post], source: DataSource)
    case loadFailed(String)
    case toggleFavorite(Int)
    case favoritesUpdated(Set<Int>)
    case toggleFavoritesFilter
}
