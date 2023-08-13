//
//  PlannerViewModel.swift
//  AITripPlanner
//
//  Created by Dan Engel on 6/23/23.
//

import Foundation

class PlannerViewModel: ObservableObject {
    @Published var destinations: [Destination] = []
    @Published var sightsToSee = ""
    @Published var location = ""
    @Published var numberOfDays = ""
    @Published var response: Itinerary?
    @Published var error: Error?
    @Published var loading: Bool = false
    @Published var showDetailsView: Bool = false
    @Published var selectedImage: String = ""
    @Published var unsplashImage: [(String, Photo)] = []
    @Published var showAlert: Bool = false
    @Published var canNavigateToResults: Bool = false
    
    private var connector = OpenAIConnector()
    private var travailAPI = TravailAPI()

    init(error: Error?, response: Itinerary?) {
        self.error = error
        self.response = response
    }
    
    func addDestination() {
        response = nil
        if checkValid() {
            let destination = Destination(name: self.location, sightsToSee: self.sightsToSee, numberOfDays: self.numberOfDays)
            destinations.append(destination)
            resetInputs()
        } else {
            showAlert = true
        }
    }
    
    func deleteDestination(at index: IndexSet) {
        response = nil
        destinations.remove(atOffsets: index)
    }
    
    func buildQuery() -> String {
        var message = ""
        if destinations.count > 1 {
            message.append("Please build a multi-destination travel itinerary. You must return the itinerary in the exact order requested. You must make recomendations for the best mode of transportation between destinations.")
            for (index, item) in destinations.enumerated() {
                var sights = ""
                if item.sightsToSee == "" {
                    sights = "the top tourist sights"
                } else {
                    sights = item.sightsToSee
                }
                if index == 0 {
                    message.append("First, I'd like to visit \(item.name) for \(item.numberOfDays) day(s) and I'd like to see or experience \(sights). ")
                } else if index == destinations.count - 1 {
                    message.append("Finally, I'd like to visit \(item.name) for \(item.numberOfDays) day(s) and I'd like to see or experience \(sights). ")
                } else {
                    message.append("Next, I'd like to visit \(item.name) for \(item.numberOfDays) day(s) and I'd like to see or experience \(sights). ")
                }
            }
        } else {
            var sights = destinations[0].sightsToSee == "" ? "the top tourist sights" : destinations[0].sightsToSee
            message.append("Please build a travel itinerary for a trip to \(destinations[0].name), that lasts \(destinations[0].numberOfDays) days and I'd like to see or experience \(sights). ")
        }

        message.append("Please provide links to any sights you recommend, consider the local holidays, crowds, and the best time of the day to visit each site. Do not include specific dates for travel. ")
        return message
    }
    
    func fetchItinerary() {
        if self.response != nil { return }
        self.loading = true
        self.canNavigateToResults = true
        let message = buildQuery()
        
        connector.logMessage(message, messageUserType: .user)

        connector.fetchOpenAIData { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.response = response
                    self.error = nil
                case .failure(let error):
                    self.error = error
                }
                self.loading = false
            }
        }
    }
    
    func fetchPhoto(destination: String) {
        for location in unsplashImage {
            if location.0 == destination { return }
        }
        self.loading = true
        queryUnSplashAPI(destination: destination) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.unsplashImage.append((destination, response.results[0]))
                case .failure(let error):
                    print("Unsplash Error: \(error)")
                }
                self.loading = false
            }
        }
    }

    func queryUnSplashAPI(destination: String, completion: @escaping (Result<UnSplashAPIResponse, Error>) -> Void) {
        let destinationNoSpaces = destination.replacingOccurrences(of: " ", with: "%20")
        let urlString = URL(string: "https://api.unsplash.com/search/photos?query=\(destinationNoSpaces)%20popular%20tourist%20destination&orientation=landscape&per_page=1")
        var request = URLRequest(url: urlString!)
        if let unsplashAPIKey = Secrets.unsplashKey {
            request.httpMethod = "GET"
            request.addValue("Client-ID \(unsplashAPIKey)", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else {
                    return
                }
                do {
                    let jsonStr = String(data: data, encoding: .utf8)!
                    let json = jsonStr.data(using: .utf8)!
                    
                    let decoder = JSONDecoder()
                    let photoResponse = try decoder.decode(UnSplashAPIResponse.self, from: json)
                    completion(.success(photoResponse))
                } catch let error {
                    completion(.failure(error))
                }
            }
            task.resume()
        } else if let error = error {
            completion(.failure(error))
        }
    }
    
    func checkValid() -> Bool {
        if location == "" {
            showAlert = true
            return false
        }
        if numberOfDays == "" {
            showAlert = true
            return false
        }
        return true
    }
    
    func selectImage() {
        let number = Int.random(in: 1...8)
        selectedImage = "image_0\(number)"
    }
    
    func resetError() {
        error = nil
    }
    
    func resetInputs() {
        sightsToSee = ""
        location = ""
        numberOfDays = ""
    }
    
    func deleteItinerary() {
        destinations = []
        response = nil
        unsplashImage = []
        error = nil
    }
}
