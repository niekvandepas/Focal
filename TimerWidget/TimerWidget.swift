//
//  TimerWidget.swift
//  TimerWidget
//
//  Created by Niek van de Pas on 28/03/2024.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), timeRemaining: 25 * 60)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), timeRemaining: 25 * 60)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let userDefaults = UserDefaults(suiteName: "group.com.Focal")
        let timeRemaining = UserDefaults(suiteName: "group.com.Focal")?.integer(forKey: "TimeRemaining") ?? 0
        let timerIsRunning = UserDefaults(suiteName: "group.com.Focal")?.bool(forKey: "TimerIsRunning")

        print("getting timeline")
        print("userDefaults object: ")
        if let v = userDefaults {
            print("yes user defaluts :)")
            print(v)
            print("here are the values for timeRemainng and timerISRUninng:")
            print(v.object(forKey: "TimerIsRunning"))
            print(v.object(forKey: "TimeRemaining"))
            print(v.bool(forKey: "TimeRemaining"))
        }
        else {
            print("no user defaluts")
        }
        print("time remaining from userd: " + timeRemaining.description)
        print("timerIsRunning from userd: " + (timerIsRunning?.description ?? "No timerIsRunning in user defaults"))
//        print("timer is running: " + timerViewModel.timerIsRunning.description)
//        print("time left: " + timerViewModel.timeRemainingFormatted)
        let entries = makeEntries(timerIsRunning: timerIsRunning ?? false, timeRemaining: timeRemaining)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    private func makeEntries(timerIsRunning: Bool, timeRemaining: Int) -> [SimpleEntry] {
        var entries: [SimpleEntry] = []
        let currentDate = Date()

        // If the timer is running, we provide a timeline with the seconds counting down
        print(timerIsRunning) // false
        print(timeRemaining) // 7

        if (timerIsRunning) {
            for secondOffset in 0 ..< timeRemaining {
                let entryDate = Calendar.current.date(byAdding: .second, value: secondOffset, to: currentDate)!
                let timeRemaining = timeRemaining - secondOffset

                let entry = SimpleEntry(date: entryDate, timeRemaining: timeRemaining)
                entries.append(entry)
            }
        }

        // If the timer is not running, we provide a single 'static' timeline entry with the time remaining
        else {
            let entry = SimpleEntry(date: Date(), timeRemaining: timeRemaining)
            entries.append(entry)
        }

        return entries
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let timeRemaining: Int
}

struct TimerWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        let timeRemainingFormatted = "\(entry.timeRemaining / 60):\(String(format: "%02d", entry.timeRemaining % 60))"

        return VStack {
            Text("Time left:")
            
            Text(timeRemainingFormatted)
        }
    }
}

struct TimerWidget: Widget {
    let kind: String = "TimerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                TimerWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                TimerWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
//        TODO
        .configurationDisplayName("Timer Widget")
        .description("Shows the current time left.")
    }
}

#Preview(as: .systemSmall) {
    TimerWidget()
} timeline: {
    SimpleEntry(date: .now, timeRemaining: 25 * 60)
    SimpleEntry(date: .now, timeRemaining: 0)
}
