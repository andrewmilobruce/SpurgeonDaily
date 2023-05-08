/**
 * Name: SpurgeonDailyWidget.swift
 * Purpose: Define widget for SpurgeonDaily
 * Author: Andrew Milo Bruce
 * Date: May 8th, 2023 (last modified)
 * Version: 1.0.1
 *
 * Description: This file is for the SpurgeonDailyWidget, an iOS widget that displays a quote on the home screen.
 * It implements IntentTimelineProvider to supply a timeline of SimpleEntry instances for the widget, generates a timeline of SimpleEntry instances for the widget to display, and loads the text file containing the daily Spurgeon quotes for the app to display.
 * The SpurgeonDailyWidgetEntryView is the view for the widget and displays the quote of the day, the author of the quote, and the current date in a white font.
 *
 * Modifications:
 *  - May 8th, 2023 - cleaned up code and added meaningful inline comments, header...
 *
 * Notes: None
 */

import WidgetKit
import SwiftUI
import Intents

// Provider implements IntentTimelineProvider to supply a timeline of SimpleEntry instances for the widget
struct Provider: IntentTimelineProvider {
    // Provides a placeholder entry to display before the widget's data is loaded
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }
    
    // Gets a snapshot of the widget's current state, to display in the widget gallery
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }
    
    // Generates a timeline of SimpleEntry instances for the widget to display
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// SimpleEntry represents a single entry in the widget's timeline
struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

// Loads the text file containing the daily Spurgeon quotes for the app to display
func loadFile() -> String {
    if let filepath = Bundle.main.path(forResource: "quotes", ofType: "txt") {
        do {
            let contents = try String(contentsOfFile: filepath)
            return contents
        } catch {
            return ("contents could not be loaded")
        }
    } else {
        return ("quotes.txt not found!")
    }
}

// Extension to Date type to enable app to determine the where the current date falls within the 365 day year
// so that it can be used to fetch today's quote
extension Date {
    var dayOfYear: Int {
        return Calendar.current.ordinality(of: .day, in: .year, for: self)!
    }
}

// SpurgeonDailyWidgetEntryView is the view for the widget
struct SpurgeonDailyWidgetEntryView : View {
    var entry: Provider.Entry
    
    // Places the list of Spurgeon quotes into a string
    let quotesString = loadFile()
    
    // Array of Spurgeon quotes
    var quotes: [String] {
        get {
            return self.quotesString.components(separatedBy: "\n")
        }
    }

    // Stores the current day of the year out of 365 to determine which quote to display later
    var day = Date().dayOfYear

    // This is the main view for the widget
    var body: some View {
        ZStack {
            // Sets the background color of the widget
            Color("primaryColor")
            VStack {
                // Displays the current date in a bold white font
                Text(Date.now.formatted(date: .complete, time: .omitted))
                    .foregroundColor(.white)
                    .bold()
                    .padding(.bottom, 0.05)
                    .font(.title2.bold())
                // Displays the quote of the day in an italic white font
                Text(quotes[day])
                    .foregroundColor(.white)
                    .italic()
                    .padding()
                    .font(.headline)
                // Displays the author of the quote in a smaller white font
                Text("- Charles Spurgeon")
                    .foregroundColor(.white)
                    .font(.subheadline)
            }
        }
    }
}

// This is the main struct for the widget
struct SpurgeonDailyWidget: Widget {
    let kind: String = "SpurgeonDailyWidget"

    var body: some WidgetConfiguration {
        // Configures the widget's intent
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            SpurgeonDailyWidgetEntryView(entry: entry)
        }
        // Sets the display name for the widget
        .configurationDisplayName("SpurgeonDaily")
        // Sets the description for the widget
        .description("Shows the SpurgeonDaily quote of the day.")
        // Specifies which widget families this widget can be used with
        .supportedFamilies([.systemLarge])
    }
}

// This struct is used to preview the widget in Xcode
struct SpurgeonDailyWidget_Previews: PreviewProvider {
    static var previews: some View {
        SpurgeonDailyWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
