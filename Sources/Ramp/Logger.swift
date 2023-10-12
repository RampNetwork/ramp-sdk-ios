import Foundation

struct Logger {
    static func debug(_ message: Any...) {
        #if DEBUG
        print("[MJ: debug]", message)
        #endif
    }
    
    static func error(_ error: Any...) {
        #if DEBUG
        print("[MJ: error]", error)
        #endif
    }
}
