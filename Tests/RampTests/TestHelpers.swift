import Foundation

let emptyDictionary: [String: Any] = [:]

extension String {
    static func random(length: Int = 10) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let characters = (0..<length).map { _ in letters.randomElement()! }
        return String(characters)
    }
}
