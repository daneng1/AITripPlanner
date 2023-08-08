//
//  TravailAPI.swift
//  AITripPlanner
//
//  Created by Dan Engel on 7/13/23.
//

import Foundation

struct Secrets {
    private static func secrets() -> [String: Any]? {
        let fileName = "Secrets"
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            print("Error: 'Secrets.json' not found")
            return nil
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            if let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                return jsonObject
            } else {
                print("Error: Couldn't deserialize 'Secrets.json' into a dictionary")
                return nil
            }
        } catch {
            print("Error: \(error)")
            return nil
        }
    }

    static var openAIKey: String? {
        guard let secrets = secrets(), let openAIKey = secrets["OPEN_AI_KEY"] as? String else {
            print("Error: 'OPEN_AI_KEY' not found in 'Secrets.json'")
            return nil
        }
        print("OPENAI Key, \(openAIKey)")
        return openAIKey
    }

    static var unsplashKey: String? {
        guard let secrets = secrets(), let unsplashKey = secrets["UNSPLASH_ACCESS_KEY"] as? String else {
            print("Error: 'UNSPLASH_ACCESS_KEY' not found in 'Secrets.json'")
            return nil
        }
        print("unsplash key,  \(unsplashKey)")
        return unsplashKey
    }
}


class TravailAPI {
    func getAPIKey(for key: String) -> String? {
        print("\(key) ----- \(String(describing: Bundle.main.infoDictionary?[key] as? String))")
        return Bundle.main.infoDictionary?[key] as? String
    }
    
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
