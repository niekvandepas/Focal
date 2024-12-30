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
                    .frame(width: 5, height: 5)
            }

            Circle()
                .foregroundStyle(currentCircleColor)
                .frame(width: 7, height: 7)

            // If there are uncompleted sessions, render an empty circle for those
            if completedSessions < goal {
                ForEach(completedSessions+1..<goal, id: \.self) { index in
                    Circle()
                        .stroke(.white, lineWidth: 1)
                        .foregroundStyle(.appRed)
                        .frame(width: 5, height: 5)
            }
            }
        }
    }
}
