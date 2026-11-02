import Foundation

protocol FavoritesServing {
    func loadIDs() -> Set<Int>
    func toggle(_ id: Int) -> Set<Int>
}
