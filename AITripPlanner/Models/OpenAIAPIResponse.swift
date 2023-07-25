//
//  OpenAIAPIResponse.swift
//  AITripPlanner
//
//  Created by Dan Engel on 6/29/23.
//

import Foundation

struct OpenAIResponse: Codable {
    var id: String?
    var object: String?
    var created: Int?
    var choices: [Choice]
    var usage: Usage?
}

struct Choice: Codable {
    var index: Int?
    var message: Message
    var finish_reason: String?
}

struct Message: Codable {
    var content: String?
    var function_call: FunctionCall
    var role: String
    
    enum CodingKeys: String, CodingKey {
        case content, role
        case function_call = "function_call"
    }
}

struct FunctionCall: Codable {
    var arguments: String
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case arguments = "arguments"
    }
}

struct Itinerary: Codable, Equatable {
    static func == (lhs: Itinerary, rhs: Itinerary) -> Bool {
        return lhs.tripTitle == rhs.tripTitle
    }
    
//    let id: String
    let tripTitle: String
    let tripPlan: [TripPlan]
    
    enum CodingKeys: String, CodingKey {
//        case id
        case tripTitle
        case tripPlan
    }
}

struct TripPlan: Codable {
    let id: String
    let destination: String
    let destinationItinerary: [DestinationItinerary]
    
    enum CodingKeys: String, CodingKey {
        case id
        case destination
        case destinationItinerary
    }
}

struct DestinationItinerary: Codable, Hashable {
    static func == (lhs: DestinationItinerary, rhs: DestinationItinerary) -> Bool {
        return lhs.dayTitle == rhs.dayTitle
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(dayTitle)
        hasher.combine(dayDescription)
        hasher.combine(dayItineraryItems)
    }
    
    let dayTitle: String
    let dayDescription: String
    let dayItineraryItems: [ItineraryItem]
    
    enum CodingKeys: String, CodingKey {
        case dayTitle, dayDescription
        case dayItineraryItems
    }
}

struct ItineraryItem: Codable, Hashable {
    let activity: String
    let activityDescription: String
    let activityTips: String
    let link: String?
    
    enum CodingKeys: String, CodingKey {
        case activity, activityTips, link, activityDescription
    }
    
    static func == (lhs: ItineraryItem, rhs: ItineraryItem) -> Bool {
        return lhs.activity == rhs.activity
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(activity)
    }
}

struct Usage: Codable {
    var prompt_tokens: Int?
    var completion_tokens: Int?
    var total_tokens: Int?
}
