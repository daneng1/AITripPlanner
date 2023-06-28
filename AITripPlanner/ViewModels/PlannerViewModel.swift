//
//  PlannerViewModel.swift
//  AITripPlanner
//
//  Created by Dan Engel on 6/23/23.
//

import Foundation

class PlannerViewModel: ObservableObject {
    
    @Published var sightsToSee = ""
    @Published var location = "seattle"
    @Published var numberOfDays = "3"
    @Published var response = ""
    @Published var error: Error?
    @Published var timeOfYear = "august"
    @Published var loading: Bool = false
    @Published var showDetailsView: Bool = false
    @Published var selectedImage: String = ""
    @Published var showAlert: Bool = false
    private var connector = OpenAIConnector()
    
    func buildQuery() {
        self.loading = true
        let message = "Can you give me an itinerary for a trip to \(location), that lasts \(numberOfDays) in \(timeOfYear) and I'd like to see or experience \(sightsToSee)? Please provide links to any sights you recommend, consider the local holidays, crowds and the best time of the day to visit each site. The response should be formatted for SwiftUI."
        connector.logMessage(message, messageUserType: .user)
        connector.sendToAssistant { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.response = response
                case .failure(let error):
                    self.error = error
                }
                self.loading = false
            }
        }
    }
    
    func checkValid() -> Bool {
        if location == "" {
            showAlert = true
            return false
        }
        if numberOfDays == "" {
            showAlert = true
            return false
        }
        if timeOfYear == "" {
            showAlert = true
            return false
        }
        return true
    }
    
    func selectImage() {
        let number = Int.random(in: 1...8)
        selectedImage = "image_0\(number)"
    }
}
