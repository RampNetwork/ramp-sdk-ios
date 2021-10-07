import Foundation

enum IncomingEvent {
    case kycInit(KycInitPayload)
    case purchaseCreated(PurchaseCreatedPayload)
    case purchaseFailed
    case widgetClose(WidgetClosePayload)
}

extension IncomingEvent: DictionaryDecodable {
    enum Error: Swift.Error { case missingType, missingPayload, unhandledType }
    
    init(dictionary: [String: Any]) throws {
        guard let eventType = dictionary["type"] as? String else { throw Error.missingType }
        let payload = dictionary["payload"]
        switch eventType {
        
        case "KYC_INIT":
            guard let payload = payload else { throw Error.missingPayload }
            let decoded: KycInitPayload = try decoder.decode(payload)
            self = .kycInit(decoded)
            
        case "PURCHASE_CREATED":
            guard let payload = payload else { throw Error.missingPayload }
            let decoded: PurchaseCreatedPayload = try decoder.decode(payload)
            self = .purchaseCreated(decoded)
            
        case "PURCHASE_FAILED": self = .purchaseFailed
            
        case "WIDGET_CLOSE":
            guard let payload = payload else { throw Error.missingPayload }
            let decoded: WidgetClosePayload = try decoder.decode(payload)
            self = .widgetClose(decoded)
            
        default: throw Error.unhandledType
        }
    }
}

// MARK: Payloads

struct KycInitPayload: Decodable {
    let email: String
    let countryCode: String
    let verificationId: Int
    let provider: String
    let apiKey: String
    let metaData: String?
}

struct PurchaseCreatedPayload: Decodable {
    let apiUrl: URL
    let purchaseViewToken: String
    let purchase: RampPurchase
}

struct WidgetClosePayload: Decodable {
    let showAlert: Bool
}
