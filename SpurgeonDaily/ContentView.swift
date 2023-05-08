/**
 * Name: ContentView.swift
 * Purpose: Define content view for SpurgeonDaily
 * Author: Andrew Milo Bruce
 * Date: May 8th, 2023 (last modified)
 * Version: 1.0.1
 *
 * Description: The code provided is for my iOS app SpurgeonDaily, which displays a daily quote from a text file.
 * The ContentView.swift file defines the styles for the app's UI elements, such as the background color, navbar position, font family, and font size. It also includes extensions for Date, Color, and UIResponder to help with various tasks, as well as a ShareSheetView struct that conforms to UIViewControllerRepresentable.
 * The ContentView struct includes state variables and a body that displays the current date, the Spurgeon quote for the day, and buttons for sharing the quote and toggling notifications.
 * The AppDelegate class handles notifications and the loadFile function loads the text file containing the quotes.
 *
 *
 * Modifications:
 *  - May 8th, 2023 - cleaned up code and added meaningful inline comments, header...
 *
 * Notes: None
 */

import SwiftUI
import UserNotifications

// Extension to enable the app to use the new primary color set in Assets.xcassets < primaryColor
extension Color {
    static let oldPrimaryColor = Color(UIColor.systemIndigo)
    static let primaryColor = Color("primaryColor")
    static let secondaryColor = Color("secondaryColor")
}

// Extension to enable the app to determine where the current date falls within the 365-day year so that it can be used to fetch today's quote
extension Date {
    var dayOfYear: Int {
        return Calendar.current.ordinality(of: .day, in: .year, for: self)!
    }
}

// Extension to find the next UIResponder of a specific type
extension UIResponder {
    func next<T: UIResponder>(ofType: T.Type) -> T? {
        let r = self.next
        if let r = r as? T ?? r?.next(ofType: T.self) {
            return r
        } else {
            return nil
        }
    }
}

// AppDelegate class that conforms to UIApplicationDelegate and UNUserNotificationCenterDelegate protocols
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    // Method called when the app finishes launching
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Ask permission for notifications
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Permission granted")
            } else {
                print("Permission denied\n")
            }
        }
        return false
    }
}

// Function to load the text file containing the daily Spurgeon quotes for the app to display
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

// ShareSheetView struct that conforms to UIViewControllerRepresentable protocol
struct ShareSheetView: UIViewControllerRepresentable {
    // Define the type for the callback function
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    // Properties of the ShareSheetView
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
    
    // Method to create a UIViewController that represents the ShareSheetView
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
    
    // Method to update the ShareSheetView's UI
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}

// ContentView struct
struct ContentView: View {
    
    // State variables
    @State private var showShareSheet = false
    @State private var sendNotifications = false
    @State private var notificationTime = false

    // String of the daily Spurgeon quotes
    let quotesString = loadFile()

    // Array of Spurgeon quotes
    var quotes: [String] {
        get {
            return self.quotesString.components(separatedBy: "\n")
        }
    }

    // Stores the current day of the year out of 365 to determine which quote to display later
    var day = Date().dayOfYear

    var body: some View {
        
        // ZStack that sets the color of the init screen
        ZStack {
            Color.primaryColor
            
            VStack {
                Spacer()
                Spacer()
                
                // Logo Image that is resizable on different iOS devices.
                Image("logo")
                    .resizable()
                    .frame(minWidth: 50.0, idealWidth: 100.0, maxWidth: 100.0, minHeight: 50.0, idealHeight: 100.0, maxHeight: 100.0)
                
                // Displays the current date in the system
                Text(Date.now.formatted(date: .complete, time: .omitted))
                    .foregroundColor(.black)
                    .font(.title2.bold())
                    .frame(width: 335, height: 60)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                
                // Displays the corresponding Spurgeon quote for this day of the year, followed by a gap and then the Spurgeon credit.
                Group {
                    Text(quotes[day])
                        .font(.headline.bold().italic())
                        .foregroundColor(.black) +
                    Text("\n\n") +
                    Text("- Charles Spurgeon")
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
                .padding()
                .frame(width: 335, height: 450)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.white).shadow(radius: 3))
                
                // Share button that enables user to share to various outlets
                Button(action: {showShareSheet = true}) {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .bold()
                        .font(.title2.bold())
                        .padding()
                        .foregroundColor(.white)
                        .frame(width: 335, height: 60)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                }
                .sheet(isPresented: $showShareSheet) {
                    // Share Sheet View
                    ShareSheetView(activityItems: ["\"\(quotes[day])".trimmingCharacters(in: .newlines) + "\"" + "\n" + "- Charles Spurgeon"])
                }
                .foregroundColor(.white)
                .bold()
                .font(.title2.bold())
                
                Spacer()
                Spacer()
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
