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
        case .longRest:
            "long rest"
        }
    }

    var color: Color {
        switch self {
        case .work:
            .workBlue
        case .rest:
            .breakGreen
        case .longRest:
            .breakGreen
        }
    }

    case work = 0
    case rest = 1 // 'break' is a reserved keyword lol
    case longRest = 2
}
