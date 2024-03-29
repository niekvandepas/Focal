//
//  TimerState.swift
//  Focal
//
//  Created by Niek van de Pas on 15/03/2024.
//

import Foundation

enum TimerState: Int, CustomStringConvertible {
    var description: String {
        switch self {
        case .work:
            "work"
        case .rest:
            "rest"
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
