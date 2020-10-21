//
//  Swifty_NewsApp.swift
//  Swifty News
//
//  Created by user on 02/10/2020.
//

import SwiftUI
import Sentry

@main
struct Swifty_NewsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        SentrySDK.start { options in
            options.dsn = "https://7ce78bc3494947af84c314c1c85b283f@o289707.ingest.sentry.io/5466141"
            options.debug = true // Enabled debug when first installing is always helpful
        }

        return true
    }
}