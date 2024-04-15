//
//  SessionMarkers.swift
//  Focal
//
//  Created by Niek van de Pas on 08/04/2024.
//

import SwiftUI

struct SessionMarkers: View {
    let goal: Int
    let completedSessions: Int
    let timerState: TimerState
    let isRunning: Bool

    var body: some View {
        let currentCircleColor = isRunning ? timerState.color : .offWhite

        HStack {
            ForEach(0..<completedSessions, id: \.self) { index in
                Circle()
                    .foregroundStyle(.workBlue)
                    .frame(width: 4, height: 4)
            }

            Circle()
                .foregroundStyle(currentCircleColor)
                .frame(width: 6, height: 6)

            ForEach(completedSessions+1..<goal, id: \.self) { index in
                Circle()
                    .stroke(.white, lineWidth: 1)
                    .foregroundStyle(.appRed)
                    .frame(width: 4, height: 4)
            }
        }
    }
}
