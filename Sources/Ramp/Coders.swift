import Foundation

let encoder = JSONEncoder()

let decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    /// custom strategy; `.iso8601` does not support fractional seconds
    /// https://forums.swift.org/t/iso8601dateformatter-fails-to-parse-a-valid-iso-8601-date/22999/19
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

private let isoFractionalFormatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter
}()

private extension JSONDecoder.DateDecodingStrategy {
    static let iso8601withFractionalSeconds = custom { decoder in
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        guard let date = isoFractionalFormatter.date(from: string)
        else { throw DecodingError.dataCorruptedError(in: container, debugDescription: "Not an ISO date: " + string) }
        return date
    }
}
