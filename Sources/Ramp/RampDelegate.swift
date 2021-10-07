import Foundation

public protocol RampDelegate: AnyObject {
    func ramp(_ rampViewController: RampViewController, didCreatePurchase purchase: RampPurchase)
    func rampPurchaseDidFail(_ rampViewController: RampViewController)
    func rampDidClose(_ rampViewController: RampViewController)
}
