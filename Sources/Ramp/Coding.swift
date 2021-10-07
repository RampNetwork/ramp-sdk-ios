import Foundation

// MARK: Convenience protocols

protocol DictionaryDecodable {
    init(dictionary: [String: Any]) throws
}

protocol MessageEventEncodable {
    func messagePayload() throws -> String
}

// MARK: Encoder/decoder

let encoder = JSONEncoder()

let decoder = JSONDecoder()

extension JSONDecoder {
    func decode<T: Decodable>(_ payload: Any) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: payload)
        let decoded = try decode(T.self, from: data)
        return decoded
    }
}
