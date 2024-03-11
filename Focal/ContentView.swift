//
//  ContentView.swift
//  Focal
//
//  Created by Niek van de Pas on 11/03/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var timeRemaining = 25 * 60;
    @State private var timerIsRunning = false;
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack {
            Text("\(timeRemaining / 60) : \(timeRemaining % 60, specifier: "%02d")")
                .font(.system(size: 50))
                .padding()
            
            Button(action: {
                timerIsRunning.toggle()
            }) {
                Text(timerIsRunning ? "Pause" : "Start")
            }
            .padding()
            .disabled(timeRemaining == 0)

        }
        .onReceive(timer, perform: { _ in
            guard timerIsRunning else {return}
            if timeRemaining > 0{
                timeRemaining -= 1
            }
            else {
                timeRemaining = 25 * 60
                timerIsRunning = false
            }
        })
        .padding()
    }
}

#Preview {
    ContentView()
}
