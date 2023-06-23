//
//  PlannerViewModel.swift
//  AITripPlanner
//
//  Created by Dan Engel on 6/23/23.
//

import Foundation

class PlannerViewModel: ObservableObject {
    @Published var sightsToSee = "space needle"
    @Published var location = "seattle"
    @Published var numberOfDays = "3"
    @Published var response = ""
    @Published var timeOfYear = "fall"
    @Published var loading: Bool = false
    private var connector = OpenAIConnector()
    
    func buildQuery() {
        loading = true
        let message = "Can you give me an itinerary for a trip to \(location), that lasts \(numberOfDays) in \(timeOfYear) and I'd like to see or experience \(sightsToSee)? Please provide links to any sights you recommend, consider the local holidays, crowds and the best time of the day to visit each site. Please place line break before each link."
        connector.logMessage(message, messageUserType: .user)
        response = connector.sendToAssistant()
        loading = false
    }
}
