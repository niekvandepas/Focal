//
//  Pill.swift
//  Focal
//
//  Created by Niek van de Pas on 15/03/2024.
//

import SwiftUI

struct Pill: View {
    var timerState: TimerState

    var body: some View {
        let color: Color = timerState == .work ? .pink : .breakGreen

        Text(timerState.description)
            .font(.headline)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Capsule().background(.green))
    }

}

