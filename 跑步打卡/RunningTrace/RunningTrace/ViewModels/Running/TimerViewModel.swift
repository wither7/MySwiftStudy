//
//  TimerViewModel.swift
//  RunningTrace
//
//  Created by 袁新杰 on 2021/12/10.
//

import Foundation


class TimerViewModel: ObservableObject {
    
    private enum TimerMode {
        case running
        case stopped
        case paused
    }
    
    private weak var timer: Timer? = nil

    // Internal states of the timer
    private var previouslyAccumulatedTime: TimeInterval = 0
    private var startDate: Date? = nil
    private var lastStopDate: Date? = nil
    private var state: TimerMode = .stopped
            
    // Published total time for the View to query
    @Published var totalAccumulatedTime: TimeInterval = 0

    var isRunning: Bool { return state == .running }
    var isStopped: Bool { return state == .stopped }
    var isPaused: Bool { return state == .paused }

    private func shutdownTimer() {
        // How long the timer was running
        let accumulatedRunningTime = Date().timeIntervalSince(startDate!)
        
        // Total running time
        previouslyAccumulatedTime += accumulatedRunningTime
        totalAccumulatedTime = previouslyAccumulatedTime

        lastStopDate = Date()
        
        // Discard the timer
        timer!.invalidate()
        timer = nil
    }
    
    func pause() {
        if state == .running {
            shutdownTimer()
            state = .paused
        }
    }
   
    func start() {
        // Only start if it is not running
        print("mark1")
        if state != .running {
            print("mark2")
            startDate = Date()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(update)), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode:RunLoop.Mode.default)
            state = .running
        }
    }
    
    // Stopping is permanent and will result in the timer being reset
    func stop() {
        if state == .running {
            print("err")
            shutdownTimer()
        }
        state = .stopped
        self.reset()
    }
    
    //用于取消暂停后更新timer
    @objc private func update() {
        totalAccumulatedTime = previouslyAccumulatedTime + Date().timeIntervalSince(startDate!)
    }
    
    // Permanently reset the timer
    func reset() {
        
        previouslyAccumulatedTime = 0
        totalAccumulatedTime = 0
    }
    
}

// global timer variable
var gInStoreTimer = TimerViewModel()
