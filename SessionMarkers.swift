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
        HStack {
            ForEach(0..<completedSessions, id: \.self) { index in
                Circle()
                    .foregroundStyle(.workBlue)
                    .frame(width: 4, height: 4)
            }
            Circle()
                .foregroundStyle(timerState.color)
                .frame(width: 6, height: 6)
            ForEach(completedSessions+1..<goal, id: \.self) { index in
                Circle()
                    .foregroundStyle(.white)
                    .frame(width: 4, height: 4)
            }
        }
    }
}
