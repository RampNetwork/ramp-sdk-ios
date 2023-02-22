import XCTest
@testable import Ramp

class OutgoingEventTests: XCTestCase {
    
    func testCorrectSendCryptoResult() throws {
        let txHash = String.random()
        let payload = SendCryptoResultPayload(txHash: txHash)
        let event = OutgoingEvent.sendCryptoResult(payload)
        let message = try event.messagePayload()
        let template = #"{"eventVersion":1,"payload":{"txHash":""# + txHash + #""},"type":"SEND_CRYPTO_RESULT"}"#
        XCTAssertEqual(message, template)
    }
    
    func testCorrectBackButtonPressed() throws {
        let event = OutgoingEvent.backButtonPressed
        let message = try event.messagePayload()
        let template = #"{"type":"BACK_BUTTON_PRESSED"}"#
        XCTAssertEqual(message, template)
    }
}
