import Foundation

enum IncomingEvent {
    case purchaseCreated(PurchaseCreatedPayload)
    case widgetClose(WidgetClosePayload)
    case purchaseFailed
    case kycInit(KycInitPayload)
}

extension IncomingEvent: DictionaryDecodable {
    enum Error: Swift.Error { case missingType, missingPayload, unknownType }
    
    init(dictionary: [String: Any]) throws {
        guard let eventType = dictionary["type"] as? String else { throw Error.missingType }
        let payload = dictionary["payload"]
        switch eventType {
        case "PURCHASE_CREATED":
            guard let payload = payload else { throw Error.missingPayload }
            let purchaseCreatedPayload = try decoder.decode(payload, to: PurchaseCreatedPayload.self)
            self = .purchaseCreated(purchaseCreatedPayload)
        case "WIDGET_CLOSE":
            guard let payload = payload else { throw Error.missingPayload }
            let widgetClosePayload = try decoder.decode(payload, to: WidgetClosePayload.self)
            self = .widgetClose(widgetClosePayload)
        case "PURCHASE_FAILED": self = .purchaseFailed
        case "KYC_INIT":
            guard let payload = payload else { throw Error.missingPayload }
            let kycInitPayload = try decoder.decode(payload, to: KycInitPayload.self)
            self = .kycInit(kycInitPayload)
        default: throw Error.missingType
        }
    }
}

// MARK: Payloads

struct KycInitPayload: Decodable {
    let email: String
    let countryCode: String
    let verificationId: Int
    let provider: String
    let apiKey: String?
    let metaData: String?
}

struct WidgetClosePayload: Decodable {
    let showAlert: Bool
}

struct PurchaseCreatedPayload: Decodable {
    let test: String
    let rampPurchase: RampPurchase
}

public struct RampPurchase: Decodable {
    let test: String
}
