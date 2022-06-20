import Foundation

public protocol RampDelegate: AnyObject {
    func ramp(_ rampViewController: RampViewController, didCreate purchase: Purchase, _ purchaseViewToken: String, _ apiUrl: URL)
    func ramp(_ rampViewController: RampViewController, didRequestOfframp payload: SendCryptoPayload, responseHandler: @escaping (String?) -> Void)
    func ramp(_ rampViewController: RampViewController, didCreate offRampPurchase: OffRampPurchase, _ purchaseViewToken: String, _ apiUrl: URL)
    func rampDidClose(_ rampViewController: RampViewController)
}
