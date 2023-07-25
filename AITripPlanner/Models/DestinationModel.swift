//
//  DestinationModel.swift
//  AITripPlanner
//
//  Created by Dan and Beth Engel on 7/24/23.
//

import Foundation

class Destination: Codable, Hashable {
    static func == (lhs: Destination, rhs: Destination) -> Bool {
        lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    init(name: String, sightsToSee: String, numberOfDays: String) {
        self.name = name
        self.sightsToSee = sightsToSee
        self.numberOfDays = numberOfDays
    }
    
    let name: String
    var sightsToSee: String
    let numberOfDays: String
}
