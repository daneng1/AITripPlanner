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
        return openAIKey
    }

    static var unsplashKey: String? {
        guard let secrets = secrets(), let unsplashKey = secrets["UNSPLASH_ACCESS_KEY"] as? String else {
            print("Error: 'UNSPLASH_ACCESS_KEY' not found in 'Secrets.json'")
            return nil
        }
        return unsplashKey
    }
}
