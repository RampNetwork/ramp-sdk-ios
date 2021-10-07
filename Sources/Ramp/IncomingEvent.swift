import Foundation

enum IncomingEvent {
    case kycInit(KycInitPayload)
    case purchaseCreated(PurchaseCreatedPayload)
    case purchaseFailed
    case widgetClose(WidgetClosePayload)
}

extension IncomingEvent: DictionaryDecodable {
    enum Error: Swift.Error { case missingType, missingPayload, unknownType }
    
    init(dictionary: [String: Any]) throws {
        guard let eventType = dictionary["type"] as? String else { throw Error.missingType }
        let payload = dictionary["payload"]
        switch eventType {
        
        case "KYC_INIT":
            guard let payload = payload else { throw Error.missingPayload }
            let kycInitPayload = try decoder.decode(payload, to: KycInitPayload.self)
            self = .kycInit(kycInitPayload)
            
        case "PURCHASE_CREATED":
            guard let payload = payload else { throw Error.missingPayload }
            let purchaseCreatedPayload = try decoder.decode(payload, to: PurchaseCreatedPayload.self)
            self = .purchaseCreated(purchaseCreatedPayload)
            
        case "PURCHASE_FAILED": self = .purchaseFailed
            
        case "WIDGET_CLOSE":
            guard let payload = payload else { throw Error.missingPayload }
            let widgetClosePayload = try decoder.decode(payload, to: WidgetClosePayload.self)
            self = .widgetClose(widgetClosePayload)
            
        default: throw Error.unknownType
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
