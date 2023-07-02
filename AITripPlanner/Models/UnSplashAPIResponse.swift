//
//  Destination.swift
//  AITripPlanner
//
//  Created by Dan Engel on 6/27/23.
//

import Foundation


struct UnSplashAPIResponse: Codable {
    let results: [Results]
}

struct Results: Codable, Hashable {
    let id: String
    let altDescription: String
    let urls: Urls
    
    enum CodingKeys: String, CodingKey {
        case id, urls, altDescription
    }
    
    static func == (lhs: Results, rhs: Results) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Urls: Codable {
    let small: String
    let regular: String
    
    enum CodingKeys: String, CodingKey {
        case small, regular
    }
}
