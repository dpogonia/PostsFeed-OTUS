import Foundation

public final class UserDefaultsStorage: DataStoring, @unchecked Sendable {
    private let defaults: UserDefaults
    private let lock = NSLock()

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    public func save(_ data: Data, forKey key: String) {
        lock.lock()
        defer { lock.unlock() }
        defaults.set(data, forKey: key)
    }

    public func load(forKey key: String) -> Data? {
        lock.lock()
        defer { lock.unlock() }
        return defaults.data(forKey: key)
    }

    public func remove(forKey key: String) {
        lock.lock()
        defer { lock.unlock() }
        defaults.removeObject(forKey: key)
    }
}
