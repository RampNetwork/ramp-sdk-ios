import Foundation
import SwiftUI

struct Constants {
    static let sdkVariant: String = "sdk-mobile"
    static let defaultUrl: String = "https://buy.ramp.network"
    static let scriptMessageHandlerName: String = "RampInstantMobile"
    
    static let rampColor: UIColor = UIColor(red: 19/255.0, green: 159/255.0, blue: 106/255.0, alpha: 1)
    
    static let closeAlertTitle = "Do you really want to close Ramp?"
    static let closeAlertMessage = "You will loose all progress and will have to start over"
    static let closeAlertYesAction = "Yes, close"
    static let closeAlertNoAction = "No, continue"
    
    static func postMessageScript(_ message: String) -> String { "window.postMessage(\(message));" }
}
