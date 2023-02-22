import Foundation

enum OutgoingEvent {
    case backButtonPressed
    case sendCryptoResult(SendCryptoResultPayload)
}

extension OutgoingEvent: MessageEventEncodable {
    
    func messagePayload() throws -> String {
        let type: String
        let payloadData: Data?
        let version: Int?
        
        switch self {
            
        case .backButtonPressed:
            type = EventType.backButtonPressed
            version = nil
            payloadData = nil
            
        case .sendCryptoResult(let payload):
            type = EventType.sendCryptoResult
            version = Constants.sendCryptoVersion
            payloadData = try encoder.encode(payload)
        }
        
        let payload: Any?
        if let payloadData {
            payload = try JSONSerialization.jsonObject(with: payloadData)
        } else { payload = nil }
        
        var dictionary: [String: Any] = [CodingKeys.type: type]
        if let payload {
            dictionary[CodingKeys.payload] = payload
        }
        if let version {
            dictionary[CodingKeys.version] = version
        }
            
        let jsonData = try JSONSerialization
            .data(withJSONObject: dictionary, options: .sortedKeys)
        
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        } else {
            throw Error.stringEncodingFailed
        }
    }
}

// MARK: - Types

extension OutgoingEvent {
    struct EventType {
        static let backButtonPressed = "BACK_BUTTON_PRESSED"
        static let sendCryptoResult = "SEND_CRYPTO_RESULT"
    }
    
    struct CodingKeys {
        static let payload = "payload"
        static let type = "type"
        static let version = "eventVersion"
    }
    
    enum Error: Swift.Error { case stringEncodingFailed }
}

// MARK: - Payloads

public struct SendCryptoResultPayload: Encodable {
    let txHash: String?
    
    public init(txHash: String? = nil) {
        self.txHash = txHash
    }
}
