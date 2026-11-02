import Foundation

public protocol DataStoring: Sendable {
    func save(_ data: Data, forKey key: String)
    func load(forKey key: String) -> Data?
    func remove(forKey key: String)
}
