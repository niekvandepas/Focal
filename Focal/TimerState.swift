//
//  TimerState.swift
//  Focal
//
//  Created by Niek van de Pas on 15/03/2024.
//

import Foundation

enum TimerState: CustomStringConvertible {
    var description: String {
        switch self {
        case .work:
            "work"
        case .rest:
            "rest"
        }
    }

    case work
    case rest // 'break' is a reserved keyword lol

    mutating func toggle() {
        switch self {
        case .work:
            self = .rest
        case .rest:
            self = .work
        }
    }
}
