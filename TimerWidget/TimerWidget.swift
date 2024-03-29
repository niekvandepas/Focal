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
        var entries: [SimpleEntry] = []

        let currentDate = Date()
        for secondOffset in 0 ..< (25 * 60) {
            let entryDate = Calendar.current.date(byAdding: .second, value: secondOffset, to: currentDate)!
            let timeRemaining = 25 * 60 - secondOffset

            let entry = SimpleEntry(date: entryDate, timeRemaining: timeRemaining)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
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
