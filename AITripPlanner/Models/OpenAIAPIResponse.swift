//
//  OpenAIAPIResponse.swift
//  AITripPlanner
//
//  Created by Dan and Beth Engel on 6/29/23.
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

struct OpenAIFunctionResponse: Codable {
    let id: String
    let location: String
    let itinerary: [Day]
    
    enum CodingKeys: String, CodingKey {
        case id, location
        case itinerary = "itinerary"
    }
}

struct Day: Codable {
    let day: String
    let itineraryItems: [ItineraryItem]
    
    enum CodingKeys: String, CodingKey {
        case day
        case itineraryItems = "itineraryItems"
    }
}

struct ItineraryItem: Codable {
    let activity: String
    let activityDescription: String
    let activityTips: String
    let link: String
    
    enum CodingKeys: String, CodingKey {
        case activity, activityTips, link, activityDescription
    }
}

struct Usage: Codable {
    var prompt_tokens: Int?
    var completion_tokens: Int?
    var total_tokens: Int?
}
