import Foundation

enum IncomingEvent {
    case onrampPurchaseCreated(OnrampPurchaseCreatedPayload)
    case widgetClose(WidgetClosePayload)
    case sendCrypto(SendCryptoPayload)
    case offrampSaleCreated(OfframpSaleCreatedPayload)
}

extension IncomingEvent {
    enum Error: Swift.Error {
        case missingType
        case missingPayload(String)
        case missingVersion(String)
        case unhandled(String, [String: Any]?, Int?)
        case unhandledVersion(String, Int)
    }
    
    init(dictionary: [String: Any]) throws {
        let type = dictionary["type"] as? String
        let payload = dictionary["payload"] as? [String: Any]
        let eventVersion = dictionary["eventVersion"] as? Int
        
        guard let type else {
            throw Error.missingType
        }
        
        switch type {
        case "PURCHASE_CREATED":
            guard let payload else {
                throw Error.missingPayload(type)
            }
            let decoded: OnrampPurchaseCreatedPayload = try decoder.decode(payload)
            self = .onrampPurchaseCreated(decoded)
            
        case "WIDGET_CLOSE":
            guard let payload else {
                throw Error.missingPayload(type)
            }
            let decoded: WidgetClosePayload = try decoder.decode(payload)
            self = .widgetClose(decoded)
            
        case "SEND_CRYPTO":
            guard let payload else {
                throw Error.missingPayload(type)
            }
            /// sendCrypto is loosely versioned, which means we accept no version or version 1 only
            if let eventVersion {
                guard eventVersion == Constants.sendCryptoVersion else {
                    throw Error.unhandledVersion(type, eventVersion)
                }
            }
            let decoded: SendCryptoPayload = try decoder.decode(payload)
            self = .sendCrypto(decoded)
            
        case "OFFRAMP_SALE_CREATED":
            guard let payload else {
                throw Error.missingPayload(type)
            }
            let decoded: OfframpSaleCreatedPayload = try decoder.decode(payload)
            self = .offrampSaleCreated(decoded)
            
        default:
            throw Error.unhandled(type, payload, eventVersion)
        }
    }
}

// MARK: - Payloads

struct OnrampPurchaseCreatedPayload: Decodable {
    let apiUrl: URL
    let purchase: OnrampPurchase
    let purchaseViewToken: String
}

struct WidgetClosePayload: Decodable {
    let showAlert: Bool
}

public struct SendCryptoPayload: Codable {
    public let assetInfo: OfframpAssetInfo
    public let amount: String
    public let address: String
}

struct OfframpSaleCreatedPayload: Decodable {
    let apiUrl: URL
    let sale: OfframpSale
    let saleViewToken: String
}
