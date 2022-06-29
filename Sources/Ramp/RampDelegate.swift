import Foundation

public protocol RampDelegate: AnyObject {
    func ramp(_ rampViewController: RampViewController, didCreatePurchase purchase: Purchase, _ purchaseViewToken: String, _ apiUrl: URL)
    func ramp(_ rampViewController: RampViewController, didRequestOfframp payload: SendCryptoPayload, responseHandler: @escaping (SendCryptoResultPayload) -> Void)
    func ramp(_ rampViewController: RampViewController, didCreateOfframpPurchase purchase: OfframpPurchase, _ purchaseViewToken: String, _ apiUrl: URL)
    func rampDidClose(_ rampViewController: RampViewController)
}
