import Foundation

struct Constants {
    static let sdkVariant: String = "sdk-mobile"
    static let defaultUrl: String = "https://buy.ramp.network"
    static let scriptMessageHandlerName: String = "RampInstantMobile"
    static let sendCryptoVersion: Int = 1
    static let sdkType: String = "IOS"
    static let sdkVersion: String = "3.0.0"
    
    static func postMessageScript(_ message: String) -> String {
        return "window.postMessage(" + message + ");"
    }
}
