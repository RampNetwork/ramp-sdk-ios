import XCTest
@testable import Ramp

class IncomingEventTests: XCTestCase {
    
    func testCorrectWidgetClose() throws {
        let showAlert = Bool.random()
        let payload: [String: Any] = ["type": "WIDGET_CLOSE",
                                      "payload": ["showAlert": showAlert]]
        let event = try IncomingEvent(dictionary: payload)
        if case .widgetClose(let payload) = event {
            XCTAssertEqual(payload.showAlert,
                           showAlert,
                           "WIDGET_CLOSE show alert flag incorrectly parsed")
        } else { XCTFail() }
    }
    
    func testCorrectSendCrypto() throws {
        let chain = String.random()
        let decimals = Int.random(in: 666...777)
        let name = String.random()
        let symbol = String.random()
        let type = String.random()
        let amount = String.random()
        let address = String.random()
        let payload: [String: Any] = ["type": "SEND_CRYPTO",
                                      "eventVersion": 1,
                                      "payload": [
                                        "assetInfo": [
                                            "chain": chain,
                                            "decimals": decimals,
                                            "name": name,
                                            "symbol": symbol,
                                            "type": type
                                        ],
                                        "amount": amount,
                                        "address": address]]
        let event = try IncomingEvent(dictionary: payload)
        if case .sendCrypto(let payload) = event {
            XCTAssertEqual(payload.assetInfo.chain, chain)
            XCTAssertEqual(payload.assetInfo.decimals, decimals)
            XCTAssertEqual(payload.assetInfo.name, name)
            XCTAssertEqual(payload.assetInfo.symbol, symbol)
            XCTAssertEqual(payload.assetInfo.type, type)
            XCTAssertEqual(payload.amount, amount)
            XCTAssertEqual(payload.address, address)
        } else { XCTFail("Failed to decode SEND_CRYPTO event") }
    }
    
    func testMissingType() throws {
        let payload: [String: Any] = [:]
        do {
            let _ = try IncomingEvent(dictionary: payload)
            XCTFail("Incorrectly decoded undefined payload")
        } catch let error as IncomingEvent.Error {
            guard case .missingType = error else {
                XCTFail("Failed to throw invalid type error")
                return
            }
        }
    }
    
    func testInvalidType() throws {
        let invalidType = "INVALID_TYPE_NON_EXISTENT_FOR_SURE_WINNIE_THE_POOH"
        let payload = ["type": invalidType]
        do {
            let _ = try IncomingEvent(dictionary: payload)
            XCTFail("Incorrectly decoded non-existent payload type")
        } catch let error as IncomingEvent.Error {
            if case .unhandledType(let type) = error {
                XCTAssertEqual(type, invalidType)
            } else {
                XCTFail("Incorrect error thrown, expected .unhandledType")
            }
        }
    }
    
    #warning("Test disabled until backend returns version")
    //    func testMissingVersionInSendCryptoEvent() throws {
    //        let payload: [String: Any] = ["type": "SEND_CRYPTO",
    //                                      "payload": emptyDictionary]
    //        do {
    //            let _ = try IncomingEvent(dictionary: payload)
    //            XCTFail("Incorrectly decoded SEND_CRYPTO payload with no version")
    //        } catch let error as IncomingEvent.Error {
    //            guard case .missingVersion = error else {
    //                XCTFail("Incorrect error thrown, expected .missingVersion")
    //                return
    //            }
    //        }
    //    }
    
    func testUnknownVersionInSendCryptoEvent() throws {
        let validType = "SEND_CRYPTO"
        let invalidVersion = Int.random(in: 666...777)
        let payload: [String: Any] = ["type": "SEND_CRYPTO",
                                      "payload": emptyDictionary,
                                      "eventVersion": invalidVersion]
        do {
            let _ = try IncomingEvent(dictionary: payload)
            XCTFail("Incorrectly decoded SEND_CRYPTO payload with invalidversion")
        } catch let error as IncomingEvent.Error {
            if case .unhandledVersion(let version, let type) = error {
                XCTAssertEqual(version, invalidVersion)
                XCTAssertEqual(type, validType)
            } else {
                XCTFail("Incorrect error thrown, expected .unhandledVersion")
            }
        }
    }
}
