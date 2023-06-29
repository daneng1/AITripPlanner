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
        print("json ***************** \(json)")
        let decoder = JSONDecoder()
        do {
            let product = try decoder.decode(OpenAIResponse.self, from: json)
            return product
            
        } catch {
            print("Error decoding OpenAI API Response -- \(error)")
        }
        
        return nil
    }
}
