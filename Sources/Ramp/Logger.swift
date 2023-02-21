import Foundation

struct Logger {
    static func debug(_ message: String) {
        #if DEBUG
        print("[debug]", message)
        #endif
    }
    
    static func error(_ error: Error) {
        #if DEBUG
        print("[error]", String(describing: error))
        #endif
    }
}
