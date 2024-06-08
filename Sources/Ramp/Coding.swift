import Foundation

// MARK: Encoder/decoder

let encoder = JSONEncoder()

let decoder = JSONDecoder()

extension JSONDecoder {
    func decode<T: Decodable>(_ payload: [String: Any]) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: payload)
        return try self.decode(T.self, from: data)
    }
}
