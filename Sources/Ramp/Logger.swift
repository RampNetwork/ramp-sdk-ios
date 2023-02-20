//
//  Logger.swift
//  
//
//  Created by Mateusz Jabłoński on 15/12/2022.
//

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
