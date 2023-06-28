//
//  Destination.swift
//  AITripPlanner
//
//  Created by Dan Engel on 6/27/23.
//

import Foundation

struct Destination: Identifiable {
    let id: String
    let name: String
    let description: String
    let timeOfYear: String
    let numberOfDays: String
    let tripPlan: [DayPlan]
    let image: String
}


struct DayPlan: Identifiable {
    let id: String
    let activities: [String]
    let link: [String]?
}

struct OpenAIFunction {
    let name: String
    let description: String
    let parameters: OpenAIParams
}

struct OpenAIParams {
    let type: String
    let properties: [OpenAIProperties]
}

struct OpenAIProperties {
    
}
