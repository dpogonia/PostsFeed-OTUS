import Foundation

public protocol IdentifiableEntity {
    associatedtype ID: Hashable
    var id: ID { get }
}

public extension Collection where Element: IdentifiableEntity {
    func first(id: Element.ID) -> Element? {
        first { $0.id == id }
    }

    func contains(id: Element.ID) -> Bool {
        contains { $0.id == id }
    }
}

public extension Array where Element: IdentifiableEntity {
    mutating func upsert(_ element: Element) {
        if let index = firstIndex(where: { $0.id == element.id }) {
            self[index] = element
        } else {
            append(element)
        }
    }
}
