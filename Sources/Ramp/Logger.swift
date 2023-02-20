import Foundation

struct Logger {
    static func debug(_ message: String) {
        #if DEBUG
        print("[RampSdk]", message)
        #endif
    }
    
    static func error(_ error: Error) {
        #if DEBUG
        print("[RampSdk]", String(describing: error))
        #endif
    }
}
