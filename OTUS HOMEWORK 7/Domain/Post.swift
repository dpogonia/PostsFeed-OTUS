import CoreServices
import Foundation

struct Post: Codable, Hashable, Identifiable, IdentifiableEntity {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}

enum DataSource: Equatable {
    case remote
    case cache
}
