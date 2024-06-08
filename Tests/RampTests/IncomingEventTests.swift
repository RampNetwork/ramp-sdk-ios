import XCTest
@testable import Ramp

class IncomingEventTests: XCTestCase {
    
    func testMissingType() {
        XCTAssertThrowsError(try IncomingEvent(dictionary: [:])) { error in
            if case IncomingEvent.Error.missingType = error {
                // pass
            } else {
                XCTFail("Expected missingType, got \(String(describing: error))")
            }
        }
    }
    
    func testInvalidType() {
        let invalidType = "INVALID_TYPE_NON_EXISTENT_FOR_SURE_WINNIE_THE_POOH"
        let eventPayload = ["type": invalidType]
        XCTAssertThrowsError(try IncomingEvent(dictionary: eventPayload)) { error in
            if case IncomingEvent.Error.unhandled = error {
                // pass
            } else {
                XCTFail("Expected missingType, got \(String(describing: error))")
            }
        }
    }
    
    func testMissingPayloads() {
        XCTAssertThrowsError(try IncomingEvent(dictionary: ["type": "PURCHASE_CREATED"])) { error in
            if case IncomingEvent.Error.missingPayload = error {
                // pass
            } else {
                XCTFail("Expected missingPayload, got \(String(describing: error))")
            }
        }
        XCTAssertThrowsError(try IncomingEvent(dictionary: ["type": "WIDGET_CLOSE"])) { error in
            if case IncomingEvent.Error.missingPayload = error {
                // pass
            } else {
                XCTFail("Expected missingPayload, got \(String(describing: error))")
            }
        }
        XCTAssertThrowsError(try IncomingEvent(dictionary: ["type": "SEND_CRYPTO"])) { error in
            if case IncomingEvent.Error.missingPayload = error {
                // pass
            } else {
                XCTFail("Expected missingPayload, got \(String(describing: error))")
            }
        }
        XCTAssertThrowsError(try IncomingEvent(dictionary: ["type": "OFFRAMP_SALE_CREATED"])) { error in
            if case IncomingEvent.Error.missingPayload = error {
                // pass
            } else {
                XCTFail("Expected missingPayload, got \(String(describing: error))")
            }
        }
    }
    
    func testCorrectPurchaseCreated() {
        let eventPayload: [String: Any] = [
            "type": "PURCHASE_CREATED",
            "payload": [
                "apiUrl": "apiUrl",
                "purchase": [
                    "appliedFee": 1.0,
                    "asset": [
                        "decimals": 1,
                        "name": "name",
                        "symbol": "symbol",
                        "type": "type",
                    ],
                    "assetExchangeRate": 1.0,
                    "baseRampFee": 1.0,
                    "createdAt": "createdAt",
                    "cryptoAmount": "cryptoAmount",
                    "fiatCurrency": "fiatCurrency",
                    "fiatValue": 1.0,
                    "id": "id",
                    "networkFee": 1.0,
                    "paymentMethodType": "paymentMethodType",
                    "receiverAddress": "receiverAddress",
                    "status": "status",
                    "updatedAt": "updatedAt",
                ],
                "purchaseViewToken": "purchaseViewToken",
            ]
        ]
        do {
            let event = try IncomingEvent(dictionary: eventPayload)
            if case .onrampPurchaseCreated = event {
                // pass
            } else {
                XCTFail("Expected onrampPurchaseCreated, got \(String(describing: event))")
            }
        } catch {
            XCTFail(String(describing: error))
        }
    }
    
    func testCorrectWidgetClose() {
        let eventPayload: [String: Any] = [
            "type": "WIDGET_CLOSE",
            "payload": ["showAlert": true]
        ]
        do {
            let event = try IncomingEvent(dictionary: eventPayload)
            if case .widgetClose = event {
                // pass
            } else {
                XCTFail("Expected widgetClose, got \(String(describing: event))")
            }
        } catch {
            XCTFail(String(describing: error))
        }
    }
    
    func testCorrectSendCrypto() {
        let eventPayload: [String: Any] = [
            "type": "SEND_CRYPTO",
            "eventVersion": 1,
            "payload": [
                "assetInfo": [
                    "chain": "chain",
                    "decimals": 1,
                    "name": "name",
                    "symbol": "symbol",
                    "type": "type"
                ],
                "amount": "amount",
                "address": "address"
            ]
        ]
        do {
            let event = try IncomingEvent(dictionary: eventPayload)
            if case .sendCrypto = event {
                // pass
            } else {
                XCTFail("Expected sendCrypto, got \(String(describing: event))")
            }
        } catch {
            XCTFail(String(describing: error))
        }
    }
    
    func testCorrectSaleCreated() {
        let eventPayload: [String: Any] = [
            "type": "OFFRAMP_SALE_CREATED",
            "payload": [
                "apiUrl": "apiUrl",
                "sale": [
                    "createdAt": "createdAt",
                    "crypto": [
                        "amount": "amount",
                        "assetInfo": [
                            "chain": "chain",
                            "decimals": 1,
                            "name": "name",
                            "symbol": "symbol",
                            "type": "type",
                        ],
                    ],
                    "fiat": [
                        "amount": 1.0,
                        "currencySymbol": "currencySymbol",
                    ],
                    "id": UUID().uuidString,
                ],
                "saleViewToken": "purchaseViewToken",
            ]
        ]
        do {
            let event = try IncomingEvent(dictionary: eventPayload)
            if case .offrampSaleCreated = event {
                // pass
            } else {
                XCTFail("Expected offrampSaleCreated, got \(String(describing: event))")
            }
        } catch {
            XCTFail(String(describing: error))
        }
    }
    
    func testUnknownVersionInSendCryptoEvent() {
        let eventPayload: [String: Any] = [
            "type": "SEND_CRYPTO",
            "payload": [:],
            "eventVersion": 666
        ]
        XCTAssertThrowsError(try IncomingEvent(dictionary: eventPayload)) { error in
            if case IncomingEvent.Error.unhandledVersion = error {
                // pass
            } else {
                XCTFail("Expected missingType, got \(String(describing: error))")
            }
        }
    }
}
