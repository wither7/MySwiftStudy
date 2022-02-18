//
//  RunningState.swift
//  RunningTrace
//
//  Created by 袁新杰 on 2021/12/9.
//

import Foundation
import SwiftUI

class RunningState: ObservableObject {
    @Published var isRunning = false
    
    func startRun() {
        isRunning = true
    }
    
    func stopRun() {
        isRunning = false
    }
}
