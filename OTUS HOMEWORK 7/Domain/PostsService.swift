import CoreServices
import Foundation

final class PostsService: PostsServing {
    private let network: any NetworkServing
    private let parser: any JSONParsing
    private let storage: any DataStoring

    private let endpoint = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    private static let cacheKey = "core.posts.cache"

    init(
        network: any NetworkServing = ServiceLocator.shared.resolve(),
        parser: any JSONParsing = ServiceLocator.shared.resolve(),
        storage: any DataStoring = ServiceLocator.shared.resolve()
    ) {
        self.network = network
        self.parser = parser
        self.storage = storage
    }

    func fetchPosts() async throws -> (posts: [Post], source: DataSource) {
        do {
            let data = try await network.data(from: endpoint)
            let posts = try parser.decodeList(Post.self, from: data)
            if let encoded = try? parser.encode(posts) {
                storage.save(encoded, forKey: Self.cacheKey)
            }
            return (posts, .remote)
        } catch {
            if let cached = storage.load(forKey: Self.cacheKey),
               let posts = try? parser.decodeList(Post.self, from: cached),
               !posts.isEmpty {
                return (posts, .cache)
            }
            throw error
        }
    }
}
