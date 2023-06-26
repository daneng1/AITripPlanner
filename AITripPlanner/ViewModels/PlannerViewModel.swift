//
//  PlannerViewModel.swift
//  AITripPlanner
//
//  Created by Dan Engel on 6/23/23.
//

import Foundation

class PlannerViewModel: ObservableObject {
    
    @Published var sightsToSee = ""
    @Published var location = ""
    @Published var numberOfDays = ""
    @Published var response = ""
    @Published var error: Error?
    @Published var timeOfYear = ""
    @Published var loading: Bool = false
    @Published var showDetailsView: Bool = false
    @Published var selectedImage: String = ""
    @Published var isQueryValid: Bool = false
    @Published var showAlert: Bool = false
    private var connector = OpenAIConnector()
    
    func buildQuery() {
        checkValid()
        if !isQueryValid {
            showAlert = true
        } else {
            self.loading = true
            let message = "Can you give me an itinerary for a trip to \(location), that lasts \(numberOfDays) in \(timeOfYear) and I'd like to see or experience \(sightsToSee)? Please provide links to any sights you recommend, consider the local holidays, crowds and the best time of the day to visit each site. Add a line break before every link and do not include any other characters with the link like parenthesis."
            connector.logMessage(message, messageUserType: .user)
            connector.sendToAssistant { (result) in
                switch result {
                case .success(let response):
                    self.response = response
                    print("Response: \(response)")
                case .failure(let error):
                    self.error = error
                    print("Error: \(error)")
                }
            }
            self.loading = false
        }
    }
    
    func checkValid() {
        if location != "" && numberOfDays != "" && timeOfYear != "" {
            isQueryValid = true
        }
    }
    
    func selectImage() {
        let number = Int.random(in: 1...8)
        selectedImage = "image_0\(number)"
    }
}
