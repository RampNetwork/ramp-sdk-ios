import WebKit
import XCTest
@testable import Ramp

class RampViewControllerTests: XCTestCase {
    func testRampViewController() throws {
        let configuration = Configuration()
        let vc = try RampViewController(configuration: configuration)
        vc.loadViewIfNeeded()
    }
    
    func testRampViewControllerViews() throws {
        let configuration = Configuration()
        let delegate = TestDelegate(
            didCreateOnrampPurchase: { _, _, _ in
                XCTFail()
            },
            didRequestSendCrypto: { _ in
                XCTFail()
            },
            didCreateOfframpSale: { _, _, _ in
                XCTFail()
            },
            didClose: {
                XCTFail()
            }
        )
        let vc = try RampViewController(configuration: configuration)
        vc.delegate = delegate
        vc.loadViewIfNeeded()
        
        let stackView = try XCTUnwrap(vc.view as? UIStackView)
        let webView = try XCTUnwrap(stackView.arrangedSubviews[0] as? WKWebView)
        _ = webView
    }
}

class TestDelegate: RampDelegate {
    let didCreateOnrampPurchase: (OnrampPurchase, String, URL) -> Void
    let didRequestSendCrypto: (SendCryptoPayload) -> Void
    let didCreateOfframpSale: (OfframpSale, String, URL) -> Void
    let didClose: () -> Void
    
    init(didCreateOnrampPurchase: @escaping (OnrampPurchase, String, URL) -> Void, didRequestSendCrypto: @escaping (SendCryptoPayload) -> Void, didCreateOfframpSale: @escaping (OfframpSale, String, URL) -> Void, didClose: @escaping () -> Void) {
        self.didCreateOnrampPurchase = didCreateOnrampPurchase
        self.didRequestSendCrypto = didRequestSendCrypto
        self.didCreateOfframpSale = didCreateOfframpSale
        self.didClose = didClose
    }
    
    func ramp(_ rampViewController: RampViewController, didCreateOnrampPurchase purchase: OnrampPurchase, _ purchaseViewToken: String, _ apiUrl: URL) {
        didCreateOnrampPurchase(purchase, purchaseViewToken, apiUrl)
    }
    
    func ramp(_ rampViewController: RampViewController, didRequestSendCrypto payload: SendCryptoPayload, responseHandler: @escaping (SendCryptoResultPayload) -> Void) {
        didRequestSendCrypto(payload)
    }
    
    func ramp(_ rampViewController: RampViewController, didCreateOfframpSale sale: OfframpSale, _ saleViewToken: String, _ apiUrl: URL) {
        didCreateOfframpSale(sale, saleViewToken, apiUrl)
    }
    
    func rampDidClose(_ rampViewController: RampViewController) {
        didClose()
    }
}
