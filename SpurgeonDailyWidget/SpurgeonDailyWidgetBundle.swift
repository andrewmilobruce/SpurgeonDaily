/**
 * Name: SpurgeonDailyWidgetBundle.swift
 * Purpose: SpurgeonDailyWidget bundle
 * Author: Andrew Milo Bruce
 * Date: May 8th, 2023 (last modified)
 * Version: 1.0.1
 *
 * Description: This file defines a widget bundle that includes two widgets, `SpurgeonDailyWidget` and `SpurgeonDailyWidgetLiveActivity`.
 * The `@main` attribute indicates that this is the entry point of the widget bundle. `SpurgeonDailyWidgetBundle` conforms to the `WidgetBundle` protocol, which requires a `body` property that returns one or more widgets. In this case, the `body` property returns both widgets included in the bundle.
 *
 * Modifications:
 *  - May 8th, 2023 - cleaned up code and added meaningful inline comments, header...
 *
 * Notes: None
 */

import WidgetKit
import SwiftUI

@main
struct SpurgeonDailyWidgetBundle: WidgetBundle {
    // The body property is a computed property that must return one or more widgets.
    var body: some Widget {
        // Here we define two widgets using the previously defined structs SpurgeonDailyWidget and SpurgeonDailyWidgetLiveActivity.
        SpurgeonDailyWidget()
        SpurgeonDailyWidgetLiveActivity()
    }
}
