//
//  OpenAIResponseHandler.swift
//  AITripPlanner
//
//  Created by Dan Engel on 6/20/23.
//

import Foundation

struct OpenAIResponseHandler {
    func decodeJson(jsonString: String) throws -> OpenAIResponse? {
        let json = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        do {
            let product = try decoder.decode(OpenAIResponse.self, from: json)
            return product
            
        } catch {
            throw error
        }
    }
    
    func decodeArgumentsJson(jsonString: String) throws -> Itinerary {
        let responseData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(Itinerary.self, from: responseData)
            return response
        } catch {
            throw error
        }
    }
}
