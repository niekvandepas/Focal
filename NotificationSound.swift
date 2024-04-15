//
//  NotificationSound.swift
//  Focal
//
//  Created by Niek van de Pas on 15/04/2024.
//

enum NotificationSound: Int {
    case bell = 0

    case arp = 1
    case buzz = 2
    case fourths = 3
    case home = 4
    case suspended = 5

    var fileName: String {
        switch self {
        case .bell:
            "Bell.wav"
        case .arp:
            "Arp.wav"
        case .buzz:
            "Buzz.wav"
        case .fourths:
            "Fourths.wav"
        case .home:
            "Home.wav"
        case .suspended:
            "Suspended.wav"
        }
    }
}

