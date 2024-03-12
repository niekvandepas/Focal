//
//  TimerViewModel.swift
//  Focal
//
//  Created by Niek van de Pas on 12/03/2024.
//

import SwiftUI
import Combine

class TimerViewModel: ObservableObject {
    @Published var timeRemaining = 25 * 60
    @Published var timerIsRunning = false
    
    private var timer: AnyCancellable?
    
    init() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                guard self.timerIsRunning else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.timeRemaining = 25 * 60
                    self.timerIsRunning = false
                }
            }
    }
    
    func toggleTimer() {
        timerIsRunning.toggle()
    }
    
    func startTimer() {
        timerIsRunning = true
    }
    
    func stopTimer() {
        timerIsRunning = false
    }
}

