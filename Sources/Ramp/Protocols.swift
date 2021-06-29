import Foundation

protocol DictionaryDecodable {
    init(dictionary: [String: Any]) throws
}

protocol MessageEventEncodable {
    func messagePayload() throws -> String
}
