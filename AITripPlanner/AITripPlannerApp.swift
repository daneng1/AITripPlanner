//
//  AITripPlannerApp.swift
//  AITripPlanner
//
//  Created by Dan and Beth Engel on 6/20/23.
//

import SwiftUI

@main
struct AITripPlannerApp: App {
    let openAIConnector = OpenAIConnector()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(openAIConnector)
        }
    }
}
