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

let decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601withFractionalSeconds
    return decoder
}()

extension JSONDecoder {
    func decode<T: Decodable>(_ payload: Any, to type: T.Type) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: payload)
        let decoded = try decode(type, from: data)
        return decoded
    }
}

private extension JSONDecoder.DateDecodingStrategy {
    /// Custom ISO 8601 strategy; default `.iso8601` does not support fractional seconds.
    /// [Discussion](https://forums.swift.org/t/iso8601dateformatter-fails-to-parse-a-valid-iso-8601-date/22999/19)
    static let iso8601withFractionalSeconds = custom { decoder in
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        guard let date = isoFractionalFormatter.date(from: string)
        else { throw DecodingError.dataCorruptedError(in: container, debugDescription: "Not an ISO date: " + string) }
        return date
    }
}

private let isoFractionalFormatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter
}()
