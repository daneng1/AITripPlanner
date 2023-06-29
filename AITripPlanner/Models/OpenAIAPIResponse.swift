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
    var arguments: OpenAIFunctionResponse
    var name: String?
}

struct Usage: Codable {
    var prompt_tokens: Int?
    var completion_tokens: Int?
    var total_tokens: Int?
}
