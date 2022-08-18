import Foundation

struct Constants {
    static let sdkVariant: String = "sdk-mobile"
    static let defaultUrl: String = "https://buy.ramp.network"
    static let scriptMessageHandlerName: String = "RampInstantMobile"
    static let sendCryptoPayloadVersion: Int = 1
    
    static func postMessageScript(_ message: String) -> String { "window.postMessage(\(message));" }
}
