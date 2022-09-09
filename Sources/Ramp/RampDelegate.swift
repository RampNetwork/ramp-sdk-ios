import Foundation

public protocol RampDelegate: AnyObject {
    func rampWidgetConfigDone(_ rampViewController: RampViewController)
    func ramp(_ rampViewController: RampViewController, didCreateOnrampPurchase purchase: OnrampPurchase, _ purchaseViewToken: String, _ apiUrl: URL)
    func ramp(_ rampViewController: RampViewController, didRequestSendCrypto payload: SendCryptoPayload, responseHandler: @escaping (SendCryptoResultPayload) -> Void)
    func ramp(_ rampViewController: RampViewController, didCreateOfframpPurchase purchase: OfframpPurchase, _ purchaseViewToken: String, _ apiUrl: URL)
    func rampDidClose(_ rampViewController: RampViewController)
}
