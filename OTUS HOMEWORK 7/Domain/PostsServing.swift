import Foundation

protocol PostsServing {
    func fetchPosts() async throws -> (posts: [Post], source: DataSource)
}
