import Foundation

struct Constants {
    static let sdkVariant: String = "sdk-mobile"
    static let defaultUrl: String = "https://buy.ramp.network"
    static let scriptMessageHandlerName: String = "RampInstantMobile"
    
    static func postMessageScript(_ message: String) -> String { "window.postMessage(\(message));" }
}
