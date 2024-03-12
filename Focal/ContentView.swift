//
//  ContentView.swift
//  Focal
//
//  Created by Niek van de Pas on 11/03/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: TimerViewModel
    
    var body: some View {
        VStack {
            Text("\(viewModel.timeRemaining / 60):\(viewModel.timeRemaining % 60, specifier: "%02d")")
                .font(.custom("SF Mono", size: 50))
                .fontWeight(.bold)
                .padding()
            
            Button(action: {
                viewModel.toggleTimer()
            }) {
                Text(viewModel.timerIsRunning ? "Pause" : "Start")
            }
            .padding()
            .disabled(viewModel.timeRemaining == 0)
        }
    }
}

//#Preview {
//    ContentView()
//}
