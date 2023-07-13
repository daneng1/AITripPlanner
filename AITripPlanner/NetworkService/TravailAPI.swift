//
//  TravailAPI.swift
//  AITripPlanner
//
//  Created by Dan Engel on 7/13/23.
//

import Foundation

class TravailAPI {
    func fetchAPIKeys(completion: @escaping (String?, String?, Error?) -> Void) {
        let url = URL(string: "https://travail-63533783d99b.herokuapp.com/api/secrets")!

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, nil, nil)
                return
            }
            
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: String] {
                    let openAIKey = jsonObject["openAIKey"]
                    let unsplashKey = jsonObject["unsplashKey"]
                    completion(openAIKey, unsplashKey, nil)
                }
            } catch {
                completion(nil, nil, error)
            }
        }
        
        task.resume()
    }
}
