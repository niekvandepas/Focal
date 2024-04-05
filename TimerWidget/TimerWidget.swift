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
        SimpleEntry(date: Date(), timeRemaining: 25 * 60, timerState: .work, timerIsRunning: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), timeRemaining: 25 * 60, timerState: .work, timerIsRunning: false)
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

                let entry = SimpleEntry(date: entryDate, timeRemaining: timeRemaining, timerState: timerState, timerIsRunning: timerIsRunning)
                entries.append(entry)
            }

            // Append a final entry that shows a paused timer in the next TimerState
            let secondOffset = timeRemaining + 1
            let entryDate = Calendar.current.date(byAdding: .second, value: secondOffset, to: currentDate)!
            let timeRemaining = timerState == .work ? 5 * 60 : 25 * 60
            let pausedNextTimerEntry = SimpleEntry(date: entryDate, timeRemaining: timeRemaining, timerState: timerState.next, timerIsRunning: timerIsRunning)
            entries.append(pausedNextTimerEntry)
        }

        // If the timer is not running, we provide a single 'static' timeline entry with the time remaining
        else {
            let entry = SimpleEntry(date: Date(), timeRemaining: timeRemaining, timerState: timerState, timerIsRunning: timerIsRunning)
            entries.append(entry)
        }

        return entries
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let timeRemaining: Int
    let timerState: TimerState
    let timerIsRunning: Bool
}

struct TimerWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        let timeRemainingFormatted = "\(entry.timeRemaining / 60):\(String(format: "%02d", entry.timeRemaining % 60))"
        let timerSquareColor: Color = entry.timerIsRunning ? entry.timerState.color : Color.offWhite

        switch family {

        case .systemSmall:
            return AnyView(Text("small"))
        case .systemMedium:
            return AnyView(MediumWidget(timerSquareColor: timerSquareColor, entry: entry, timeRemainingFormatted: timeRemainingFormatted))
        case .systemLarge:
            return AnyView(Text("large"))
        case .systemExtraLarge:
            return AnyView(Text("extra large"))
        case .accessoryCircular:
            return AnyView(Text("circle"))
        case .accessoryRectangular:
            return AnyView(Text("rectangle"))
        case .accessoryInline:
            return AnyView(Text("inline"))
        @unknown default:
            return AnyView(Text("default"))
        }
    }
}

struct MediumWidget: View {
    let timerSquareColor: Color
    let entry: SimpleEntry
    let timeRemainingFormatted: String

    var body: some View {
        return HStack {
            ZStack {
                Rectangle()
                    .fill(timerSquareColor)
                    .frame(width: 100, height: 80)
                    .multilineTextAlignment(.center)
                    .cornerRadius(8)
                    .shadow(radius: 1, x: 5, y: 5)
                    .padding(.bottom, 10)

                VStack {
                    //                TODO
                    //                if settingsManager.showTimeLeft {
                    //                    Text(timerLabelText)
                    //                        .font(.custom("Inter", size: timerStateLabelFontSize))
                    //                        .padding(.bottom, -20)
                    //                        .foregroundStyle(.black)
                    //                }

                    Text(entry.timerState.description.capitalized)

                    Text(timeRemainingFormatted)
                        .padding()
                        .foregroundStyle(.primaryButton)

                }
                .font(.custom("Inter", size: 16))
            }
            HStack {
                Spacer()
                Text("start")
                Spacer()
                Text("reset")
                Spacer()
            }
        }

    }
}

struct SmallWidget: View {
    let timerSquareColor: Color
    let entry: SimpleEntry
    let timeRemainingFormatted: String

    var body: some View {
        return HStack {
            ZStack {
                Rectangle()
                    .fill(timerSquareColor)
                    .frame(width: 100, height: 80)
                    .multilineTextAlignment(.center)
                    .cornerRadius(8)
                    .shadow(radius: 1, x: 5, y: 5)
                    .padding(.bottom, 10)

                VStack {
                    //                TODO
                    //                if settingsManager.showTimeLeft {
                    //                    Text(timerLabelText)
                    //                        .font(.custom("Inter", size: timerStateLabelFontSize))
                    //                        .padding(.bottom, -20)
                    //                        .foregroundStyle(.black)
                    //                }

                    Text(entry.timerState.description.capitalized)

                    Text(timeRemainingFormatted)
                        .padding()
                        .foregroundStyle(.primaryButton)

                }
                .font(.custom("Inter", size: 16))
            }
            HStack {
                Spacer()
                Text("start")
                Spacer()
                Text("reset")
                Spacer()
            }
        }

    }
}

struct TimerWidget: Widget {
    let kind: String = "TimerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                TimerWidgetEntryView(entry: entry)
                    .containerBackground(.accent, for: .widget)
            } else {
                TimerWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        //        TODO
        .configurationDisplayName("Timer Widget")
        .description("Shows the current time left.")
        .supportedFamilies([.systemExtraLarge, .systemLarge, .systemMedium, .systemSmall])
    }
}

//#Preview(as: .systemSmall) {
//    TimerWidget()
//} timeline: {
//    SimpleEntry(date: .now, timeRemaining: 25 * 60)
//    SimpleEntry(date: .now, timeRemaining: 0)
//}
