import Foundation

enum IncomingEvent {
    case widgetConfigDone
    case kycInit(KycInitPayload)
    case onrampPurchaseCreated(OnrampPurchaseCreatedPayload)
    case widgetClose(WidgetClosePayload)
    case sendCrypto(SendCryptoPayload)
    case offrampPurchaseCreated(OfframpPurchaseCreatedPayload)
}

extension IncomingEvent: DictionaryDecodable {
    
    init(dictionary: [String: Any]) throws {
        let type = dictionary[CodingKeys.type] as? String
        let payload = dictionary[CodingKeys.payload] as? [String: Any]
        let version = dictionary[CodingKeys.version] as? Int
        
        guard let type = type else { throw Error.missingType }
        
        switch type {
            
        case EventTypes.widgetConfigDone:
            self = .widgetConfigDone
            
        case EventTypes.kycInit:
            guard let payload = payload else { throw Error.missingPayload(type) }
            let decoded: KycInitPayload = try decoder.decode(payload)
            self = .kycInit(decoded)
            
        case EventTypes.onrampPurchaseCreated:
            guard let payload = payload  else { throw Error.missingPayload(type) }
            let decoded: OnrampPurchaseCreatedPayload = try decoder.decode(payload)
            self = .onrampPurchaseCreated(decoded)
            
        case EventTypes.widgetClose:
            guard let payload = payload  else { throw Error.missingPayload(type) }
            let decoded: WidgetClosePayload = try decoder.decode(payload)
            self = .widgetClose(decoded)
            
        case EventTypes.sendCrypto:
            guard let payload = payload  else { throw Error.missingPayload(type) }
            /// sendCrypto is loosely versioned, which means we accept no version or version 1 only
            if let version = version, version != Constants.sendCryptoVersion {
                throw Error.unhandledVersion(version, type)
            }
            let decoded: SendCryptoPayload = try decoder.decode(payload)
            self = .sendCrypto(decoded)
            
        case EventTypes.offrampPurchaseCreated:
            guard let payload = payload  else { throw Error.missingPayload(type) }
            let decoded: OfframpPurchaseCreatedPayload = try decoder.decode(payload)
            self = .offrampPurchaseCreated(decoded)
            
        default:
            throw Error.unhandledType(type)
        }
    }
}

// MARK: - Types

extension IncomingEvent {
    struct EventTypes {
        static let widgetConfigDone = "WIDGET_CONFIG_DONE"
        static let kycInit = "KYC_INIT"
        static let onrampPurchaseCreated = "PURCHASE_CREATED"
        static let widgetClose = "WIDGET_CLOSE"
        static let sendCrypto = "SEND_CRYPTO"
        static let offrampPurchaseCreated = "OFFRAMP_PURCHASE_CREATED"
    }
    
    struct CodingKeys {
        static let payload = "payload"
        static let type = "type"
        static let version = "eventVersion"
    }
    
    enum Error: Swift.Error {
        case missingType, missingPayload(String), missingVersion(String)
        case unhandledType(String), unhandledVersion(Int, String)
    }
}

// MARK: - Payloads

struct KycInitPayload: Decodable {
    let email: String
    let countryCode: String
    let verificationId: Int
    let provider: String
    let apiKey: String
    let metaData: String?
}

struct OnrampPurchaseCreatedPayload: Decodable {
    let apiUrl: URL
    let purchaseViewToken: String
    let purchase: OnrampPurchase
}

struct WidgetClosePayload: Decodable {
    let showAlert: Bool
}

public struct SendCryptoPayload: Decodable {
    public let assetSymbol: String
    public let amount: String
    public let address: String
}

struct OfframpPurchaseCreatedPayload: Decodable {
    let apiUrl: URL
    let purchase: OfframpPurchase
    let purchaseViewToken: String
}
