//
//  TimerState.swift
//  Focal
//
//  Created by Niek van de Pas on 15/03/2024.
//

import SwiftUI

enum TimerState: Int, CustomStringConvertible {
    var description: String {
        switch self {
        case .work:
            "work"
        case .rest:
            "rest"
        }
    }

    /// Returns the next TimerState: 'work' if the current state is 'rest', and vice versa. Does not mutate self.
    var next: TimerState {
        switch self {
        case .work:
            return .rest
        case .rest:
            return .work
        }
    }

    var color: Color {
        switch self {
        case .work:
            .workBlue
        case .rest:
            .breakGreen
        }
    }

    case work = 0
    case rest = 1 // 'break' is a reserved keyword lol

    mutating func toggle() {
        switch self {
        case .work:
            self = .rest
        case .rest:
            self = .work
        }
    }
}
