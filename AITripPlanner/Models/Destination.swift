//
//  Destination.swift
//  AITripPlanner
//
//  Created by Dan Engel on 6/27/23.
//

import Foundation

//struct Destination: Identifiable {
//    let id: String
//    let name: String
//    let description: String
//    let timeOfYear: String
//    let numberOfDays: String
//    let tripPlan: [DayPlan]
//    let image: String
//}
//
//struct DayPlan: Identifiable {
//    let id: String
//    let activities: [String]
//    let link: [String]?
//}

struct OpenAIFunctionResponse: Codable {
    let id: String
    let location: String
    let itinerary: [Day]
}

struct Day: Codable {
    let day: String
    let itineraryItems: [ItineraryItem]
    
    enum CodingKeys: String, CodingKey {
        case day, itineraryItems
    }
}

struct ItineraryItem: Codable {
    let activity: String
    let activityDescription: String
    let activityTips: String
    let link: String
    
    enum CodingKeys: String, CodingKey {
        case activity, activityTips, link
        case activityDescription = "activity_description"
    }
}
