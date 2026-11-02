import CoreServices
import Foundation

final class FavoritesService: FavoritesServing {
    private let parser: any JSONParsing
    private let storage: any DataStoring

    private static let storageKey = "core.favorites.ids"

    init(
        parser: any JSONParsing = ServiceLocator.shared.resolve(),
        storage: any DataStoring = ServiceLocator.shared.resolve()
    ) {
        self.parser = parser
        self.storage = storage
    }

    func loadIDs() -> Set<Int> {
        guard let data = storage.load(forKey: Self.storageKey),
              let ids = try? parser.decode([Int].self, from: data) else {
            return []
        }
        return Set(ids)
    }

    func toggle(_ id: Int) -> Set<Int> {
        var ids = loadIDs()
        if ids.contains(id) {
            ids.remove(id)
        } else {
            ids.insert(id)
        }
        if let data = try? parser.encode(Array(ids)) {
            storage.save(data, forKey: Self.storageKey)
        }
        return ids
    }
}
