import Foundation

public protocol RampDelegate: AnyObject {
    func ramp(_ rampViewController: RampViewController, didCreatePurchase purchase: RampPurchase, purchaseViewToken: String, apiUrl: URL)
    func rampPurchaseDidFail(_ rampViewController: RampViewController)
    func rampDidClose(_ rampViewController: RampViewController)
}
