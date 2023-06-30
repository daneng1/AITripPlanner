//
//  OpenAIResponseHandler.swift
//  AITripPlanner
//
//  Created by Dan Engel on 6/20/23.
//

import Foundation

struct OpenAIResponseHandler {
    func decodeJson(jsonString: String) -> OpenAIResponse? {
        let json = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        do {
            let product = try decoder.decode(OpenAIResponse.self, from: json)
            return product
            
        } catch {
            print("Error decoding OpenAI API Response -- \(error)")
        }
        
        return nil
    }
    
    func decodeArgs(jsonString: String) -> OpenAIFunctionResponse? {
        let responseData = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(OpenAIFunctionResponse.self, from: responseData)
            return response
        } catch {
            print("Error deserializing JSON: \(error)")
        }
        return nil
    }
}
