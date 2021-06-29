import Foundation

let encoder = JSONEncoder()
let decoder = JSONDecoder()

extension JSONDecoder {
    func decode<T: Decodable>(_ payload: Any, to type: T.Type) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: payload)
        let decoded = try decode(type, from: data)
        return decoded
    }
}
