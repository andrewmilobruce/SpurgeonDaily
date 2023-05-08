/**
 * Name: SpurgeonDailyWidgetLiveActivity.swift
 * Purpose: Implementation of SpurgeonDailyWidget
 * Author: Andrew Milo Bruce
 * Date: May 8th, 2023 (last modified)
 * Version: 1.0.1
 *
 * Description: This is a Swift file for the SpurgeonDailyWidget iOS app.
 * It contains the implementation of a Widget using the WidgetKit framework, which displays dynamic and static content on the lock screen and in the widget's expanded view.
 * The SpurgeonDailyWidgetAttributes struct defines the activity's attributes, and the SpurgeonDailyWidgetLiveActivity struct is the main Widget configuration that includes the UI for the widget's different states.
 *
 * Modifications:
 *  - May 8th, 2023 - cleaned up code and added meaningful inline comments, header...
 *
 * Notes: None
 */

import ActivityKit
import WidgetKit
import SwiftUI

struct SpurgeonDailyWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var value: Int
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}


struct SpurgeonDailyWidgetLiveActivity: Widget {
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SpurgeonDailyWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text("Min")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}
