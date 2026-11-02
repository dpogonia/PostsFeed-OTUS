import Foundation

struct FeedState: Equatable {
    var posts: [Post] = []
    var favoriteIDs: Set<Int> = []
    var isLoading = false
    var errorMessage: String?
    var showsFavoritesOnly = false
    var source: DataSource?

    var visiblePosts: [Post] {
        showsFavoritesOnly
            ? posts.filter { favoriteIDs.contains($0.id) }
            : posts
    }
}
