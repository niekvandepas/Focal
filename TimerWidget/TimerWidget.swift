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
        SimpleEntry(date: Date(), timeRemaining: 25 * 60, timerState: .work)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), timeRemaining: 25 * 60, timerState: .work)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let userDefaults = UserDefaults(suiteName: Constants.UD_GROUP_NAME)
        let timeRemaining = userDefaults?.integer(forKey: Constants.UD_TIME_REMAINING) ?? 0
        let timerIsRunning = userDefaults?.bool(forKey: Constants.UD_TIMER_IS_RUNNING)
        let timerStateRawValue = userDefaults?.integer(forKey: Constants.UD_TIMER_STATE)
        let timerState = TimerState(rawValue: timerStateRawValue ?? 0) ?? .work

        let entries = makeEntries(timerIsRunning: timerIsRunning ?? false, timeRemaining: timeRemaining, timerState: timerState)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    private func makeEntries(timerIsRunning: Bool, timeRemaining: Int, timerState: TimerState) -> [SimpleEntry] {
        var entries: [SimpleEntry] = []
        let currentDate = Date()

        // If the timer is running, we provide a timeline with the seconds counting down
        if (timerIsRunning) {
            for secondOffset in 0 ..< timeRemaining {
                let entryDate = Calendar.current.date(byAdding: .second, value: secondOffset, to: currentDate)!
                let timeRemaining = timeRemaining - secondOffset

                let entry = SimpleEntry(date: entryDate, timeRemaining: timeRemaining, timerState: timerState)
                entries.append(entry)
            }
        }

        // If the timer is not running, we provide a single 'static' timeline entry with the time remaining
        else {
            let entry = SimpleEntry(date: Date(), timeRemaining: timeRemaining, timerState: timerState)
            entries.append(entry)
        }

        return entries
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let timeRemaining: Int
    let timerState: TimerState
}

struct TimerWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        let timeRemainingFormatted = "\(entry.timeRemaining / 60):\(String(format: "%02d", entry.timeRemaining % 60))"

        return VStack {
            Text("Time left:")
            Text(timeRemainingFormatted)

            Text("Timer state:")
            Text(entry.timerState.description)
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

//#Preview(as: .systemSmall) {
//    TimerWidget()
//} timeline: {
//    SimpleEntry(date: .now, timeRemaining: 25 * 60)
//    SimpleEntry(date: .now, timeRemaining: 0)
//}
