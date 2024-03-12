//
//  FocalApp.swift
//  Focal
//
//  Created by Niek van de Pas on 11/03/2024.
//

import SwiftUI

@main
struct FocalApp: App {
    @StateObject var timerViewModel = TimerViewModel()

    var body: some Scene {
        MenuBarExtra("Focal", systemImage: "clock") {
            AppMenu(viewModel: timerViewModel)
        }
        WindowGroup {
            ContentView(viewModel: timerViewModel)
        }
        .defaultSize(width: 300, height: 200)
    }
}


struct AppMenu: View {
    @StateObject var viewModel: TimerViewModel

    var body: some View {
        Button(action: viewModel.startTimer, label: { Text("Start") }).disabled(viewModel.timerIsRunning)
        Button(action: viewModel.stopTimer, label: { Text("Stop") }).disabled(!viewModel.timerIsRunning)
    }
}
