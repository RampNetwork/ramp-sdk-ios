import Foundation

public extension Notification.Name {
    static let rampCallback = Notification.Name("RampCallbackNotificationName")
}

public protocol RampDelegate: AnyObject {
    func ramp(_ rampViewController: RampViewController, didCreatePurchase purchase: RampPurchase)
    func rampPurchaseDidFail(_ rampViewController: RampViewController)
    func rampDidClose(_ rampViewController: RampViewController)
    func ramp(_ rampViewController: RampViewController, didRaiseError error: Error)
}

public extension RampDelegate {
    func ramp(_ rampViewController: RampViewController, didRaiseError error: Error) {}
}
