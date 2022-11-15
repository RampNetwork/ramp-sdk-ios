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
    
    func testCorrectKycStarted() throws {
        let verificationId = Int.random(in: 666...777)
        let payload = KycStartedPayload(verificationId: verificationId)
        let event = OutgoingEvent.kycStarted(payload)
        let message = try event.messagePayload()
        let template = #"{"payload":{"verificationId":"# + String(verificationId) + #"},"type":"KYC_STARTED"}"#
        XCTAssertEqual(message, template)
    }
}
