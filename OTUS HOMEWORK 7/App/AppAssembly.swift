import CoreServices
import Foundation

enum AppAssembly {
    private static var didBootstrap = false

    static func bootstrap() {
        guard !didBootstrap else { return }
        didBootstrap = true

        let locator = ServiceLocator.shared

        locator.register((any NetworkServing).self, instance: URLSessionNetworkService())
        locator.register((any JSONParsing).self, instance: JSONParser())
        locator.register((any DataStoring).self, instance: UserDefaultsStorage())

        locator.register((any PostsServing).self, instance: PostsService())
        locator.register((any FavoritesServing).self, instance: FavoritesService())
    }

    #if DEBUG
    static func bootstrapPreview() {
        ServiceLocator.shared.reset()
        didBootstrap = false

        let locator = ServiceLocator.shared
        locator.register((any NetworkServing).self, instance: PreviewNetworkService())
        locator.register((any JSONParsing).self, instance: JSONParser())
        locator.register((any DataStoring).self, instance: UserDefaultsStorage(defaults: UserDefaults(suiteName: "preview.core") ?? .standard))
        locator.register((any PostsServing).self, instance: PostsService())
        locator.register((any FavoritesServing).self, instance: FavoritesService())
        didBootstrap = true
    }
    #endif
}

#if DEBUG
struct PreviewNetworkService: NetworkServing {
    func data(from url: URL) async throws -> Data {
        let posts = [
            Post(id: 1, userId: 1, title: "Protocol Oriented Programming", body: "Сервисы зависят от протоколов, а не от конкретных типов."),
            Post(id: 2, userId: 1, title: "Service Locator и DI", body: "Зависимости регистрируются в локаторе и видны в свойствах класса."),
            Post(id: 3, userId: 1, title: "Flux / Redux", body: "Однонаправленный поток: Action -> Reducer -> State -> View.")
        ]
        return try JSONEncoder().encode(posts)
    }
}
#endif
