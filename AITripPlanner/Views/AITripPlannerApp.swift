//
//  AITripPlannerApp.swift
//  AITripPlanner
//
//  Created by Dan Engel on 6/20/23.
//

import SwiftUI

@main
struct AITripPlannerApp: App {
    let openAIConnector = OpenAIConnector()
    @StateObject var viewModel = PlannerViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(openAIConnector)
                .environmentObject(viewModel)
        }
    }
}
