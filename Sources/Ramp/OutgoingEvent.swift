import Foundation

enum OutgoingEvent {
    case kycStarted(KycStartedPayload)
    case kycSubmitted(KycSubmittedPayload)
    case kycSuccess(KycSuccessPayload)
    case kycAborted(KycAbortedPayload)
    case kycError(KycErrorPayload)
    case backButtonPressed
    case sendCryptoResult(SendCryptoResultPayload)
}

extension OutgoingEvent: MessageEventEncodable {
    
    func messagePayload() throws -> String {
        let type: String
        let payloadData: Data?
        let version: Int?
        
        switch self {
            
        case .kycStarted(let payload):
            type = EventType.kycStarted
            version = nil
            payloadData = try encoder.encode(payload)
            
        case .kycSubmitted(let payload):
            type = EventType.kycSubmitted
            version = nil
            payloadData = try encoder.encode(payload)
            
        case .kycSuccess(let payload):
            type = EventType.kycSuccess
            version = nil
            payloadData = try encoder.encode(payload)
            
        case .kycAborted(let payload):
            type = EventType.kycAborted
            version = nil
            payloadData = try encoder.encode(payload)
            
        case .kycError(let payload):
            type = EventType.kycError
            version = nil
            payloadData = try encoder.encode(payload)
            
        case .backButtonPressed:
            type = EventType.backButtonPressed
            version = nil
            payloadData = nil
            
        case .sendCryptoResult(let payload):
            type = EventType.sendCryptoResult
            version = Constants.sendCryptoPayloadVersion
            payloadData = try encoder.encode(payload)
        }
        
        let payload: Any?
        if let payloadData = payloadData { payload = try JSONSerialization.jsonObject(with: payloadData) }
        else { payload = nil }
        
        let dictionary = [CodingKeys.type: type, CodingKeys.payload: payload, CodingKeys.version: version]
        
        let jsonData = try JSONSerialization.data(withJSONObject: dictionary)
        
        if let jsonString = String(data: jsonData, encoding: .utf8) { return jsonString }
        else { throw Error.stringEncodingFailed }
    }
}

// MARK: - Types

extension OutgoingEvent {
    struct EventType {
        static let kycStarted = "KYC_STARTED"
        static let kycSubmitted = "KYC_SUBMITTED"
        static let kycSuccess = "KYC_SUCCESS"
        static let kycAborted = "KYC_ABORTED"
        static let kycError = "KYC_ERROR"
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

struct KycStartedPayload: Encodable {
    let verificationId: Int
}

struct KycSubmittedPayload: Encodable {
    let verificationId: Int
    let identityAccessKey: String
}

struct KycSuccessPayload: Encodable {
    let verificationId: Int
    let identityAccessKey: String
}

struct KycAbortedPayload: Encodable {
    let verificationId: Int
}

struct KycErrorPayload: Encodable {
    let verificationId: Int
}

public struct SendCryptoResultPayload: Encodable {
    let txHash: String?
    
    public init(txHash: String? = nil) {
        self.txHash = txHash
    }
}
