import XCTest
@testable import Ramp

class IncomingEventTests: XCTestCase {
    
    func testCorrectWidgetConfigDone() throws {
        let payload = ["type": "WIDGET_CONFIG_DONE"]
        let event = try IncomingEvent(dictionary: payload)
        if case .widgetConfigDone = event {} else { XCTFail() }
    }
    
    func testCorrectWidgetClose() throws {
        let showAlert = Bool.random()
        let payload: [String: Any] = ["type": "WIDGET_CLOSE",
                                      "payload": ["showAlert": showAlert]]
        let event = try IncomingEvent(dictionary: payload)
        if case .widgetClose(let payload) = event {
            XCTAssertEqual(payload.showAlert, showAlert)
        } else { XCTFail() }
    }
    
    func testCorrectSendCrypto() throws {
        let assetSymbol = String.random()
        let amount = String.random()
        let address = String.random()
        let payload: [String: Any] = ["type": "SEND_CRYPTO",
                                      "eventVersion": 1,
                                      "payload": ["assetSymbol": assetSymbol,
                                                  "amount": amount,
                                                  "address": address]]
        let event = try IncomingEvent(dictionary: payload)
        if case .sendCrypto(let payload) = event {
            XCTAssertEqual(payload.assetSymbol, assetSymbol)
            XCTAssertEqual(payload.amount, amount)
            XCTAssertEqual(payload.address, address)
        } else { XCTFail() }
    }
    
    func testMissingType() throws {
        let payload: [String: Any] = [:]
        do {
            let _ = try IncomingEvent(dictionary: payload)
            XCTFail()
        } catch let error as IncomingEvent.Error {
            if case .missingType = error {} else { XCTFail() }
        }
    }
    
    func testInvalidType() throws {
        let invalidType = "INVALID_TYPE_NON_EXISTENT_FOR_SURE_WINNIE_THE_POOH"
        let payload = ["type": invalidType]
        do {
            let _ = try IncomingEvent(dictionary: payload)
            XCTFail()
        } catch let error as IncomingEvent.Error {
            if case .unhandledType(let type) = error {
                XCTAssertEqual(type, invalidType)
            } else { XCTFail() }
        }
    }
    
    func testMissingVersionInSendCryptoEvent() throws {
        let payload: [String: Any] = ["type": "SEND_CRYPTO",
                                      "payload": emptyDictionary]
        do {
            let _ = try IncomingEvent(dictionary: payload)
            XCTFail()
        } catch let error as IncomingEvent.Error {
            if case .missingVersion = error {} else { XCTFail() }
        }
    }
    
    func testUnknownVersionInSendCryptoEvent() throws {
        let invalidVersion = Int.random(in: 666...777)
        let payload: [String: Any] = ["type": "SEND_CRYPTO",
                                      "payload": emptyDictionary,
                                      "eventVersion": invalidVersion]
        do {
            let _ = try IncomingEvent(dictionary: payload)
            XCTFail()
        } catch let error as IncomingEvent.Error {
            if case .unhandledVersion(let version) = error {
                XCTAssertEqual(version, invalidVersion)
            } else { XCTFail() }
        }
    }
}
