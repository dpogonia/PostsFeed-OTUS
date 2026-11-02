import Foundation

public enum NetworkError: Error, Equatable {
    case invalidResponse
    case statusCode(Int)
}

public protocol NetworkServing: Sendable {
    func data(from url: URL) async throws -> Data
}
