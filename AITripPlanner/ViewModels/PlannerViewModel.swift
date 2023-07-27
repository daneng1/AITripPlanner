//
//  PlannerViewModel.swift
//  AITripPlanner
//
//  Created by Dan Engel on 6/23/23.
//

import Foundation
import MapKit
import CoreLocation

class PlannerViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var destinations: [Destination] = []
    @Published var sightsToSee = ""
    @Published var location = ""
    @Published var numberOfDays = ""
    @Published var response: Itinerary?
    @Published var error: Error?
    @Published var timeOfYear = ""
    @Published var loading: Bool = false
    @Published var showDetailsView: Bool = false
    @Published var selectedImage: String = ""
    @Published var unsplashImage: Results?
    @Published var showAlert: Bool = false
    @Published var canNavigateToResults: Bool = false
    @Published var suggestions: [MKLocalSearchCompletion] = []
    
    private var connector = OpenAIConnector()
    private var travailAPI = TravailAPI()
    var completer = MKLocalSearchCompleter()

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        print(completer.results)
        let filteredResults = completer.results.filter {
            completion in
            return completion.title.contains(",") || !completion.subtitle.contains(",")
        }
        suggestions = filteredResults
    }
    
    init(unsplashImage: Results?, error: Error?, response: Itinerary?) {
        super.init()
        self.unsplashImage = unsplashImage
        self.error = error
        self.response = response
        completer.resultTypes = .address
        completer.delegate = self
    }
    
    func addDestination() {
        if checkValid() {
            let destination = Destination(name: self.location, sightsToSee: self.sightsToSee, numberOfDays: self.numberOfDays)
            destinations.append(destination)
            resetInputs()
        } else {
            showAlert = true
        }
    }
    
    func setLocation(location: String) {
        self.suggestions = []
        self.location = location
    }
    
    func deleteDestination(at index: IndexSet) {
        destinations.remove(atOffsets: index)
    }
    
    func buildQuery() {
        self.loading = true
        self.canNavigateToResults = true
        var message = ""
        if destinations.count > 1 {
            message.append("Please build a multi-destination travel itinerary. You must return the itinerary in the exact order requested. You must include travel days to get between each destination. You must make recomendation for the best mode of transportation between destinations. ")
            for (index, item) in destinations.enumerated() {
                var sights = ""
                if item.sightsToSee == "" {
                    sights = "the top tourist sights"
                } else {
                    sights = sightsToSee
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
            if destinations[0].sightsToSee == "" {
                destinations[0].sightsToSee = "the top tourist sights"
            }
            message.append("Please build a travel itinerary for a trip to \(destinations[0].name), that lasts \(destinations[0].numberOfDays) days and I'd like to see or experience \(destinations[0].sightsToSee). ")
        }
        message.append("Please provide links to any sights you recommend, consider the local holidays, crowds, and the best time of the day to visit each site. Do not include specific dates for travel. ")
        print("******* \(message)")
        connector.logMessage(message, messageUserType: .user)
        
//        fetchPhoto { (result) in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let response):
//                    self.unsplashImage = response.results[0]
//                case .failure(let error):
//                    print("Unsplash Error: \(error)")
//                }
//            }
//        }
        connector.sendToAssistant { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.response = response
                case .failure(let error):
                    self.error = error
                }
                self.loading = false
            }
        }
    }
//    
//    func getAPIKey(for key: String) -> String? {
//        return ProcessInfo.processInfo.environment[key]
//    }
    
    func fetchPhoto(destination: String) {
        queryUnSplashAPI(destination: destination) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.unsplashImage = response.results[0]
                case .failure(let error):
                    print("Unsplash Error: \(error)")
                }
            }
        }
    }

    func queryUnSplashAPI(destination: String, completion: @escaping (Result<UnSplashAPIResponse, Error>) -> Void) {
        let destinationNoSpaces = destination.replacingOccurrences(of: " ", with: "%20")
        let urlString = URL(string: "https://api.unsplash.com/search/photos?query=\(destinationNoSpaces)%20popular%20tourist%20destination&orientation=landscape&per_page=1")
        var request = URLRequest(url: urlString!)
        travailAPI.fetchAPIKeys { (_, unsplashKey, error) in
            if let error = error {
                completion(.failure(error))
            } else if let unsplashKey = unsplashKey {
                request.httpMethod = "GET"
                request.addValue("Client-ID \(unsplashKey)", forHTTPHeaderField: "Authorization")
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    guard let data = data else {
                        print("there was an issue with the response from Unsplash")
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
            }
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
    
    func resetData() {
        response = nil
        unsplashImage = nil
    }
    
    func resetError() {
        error = nil
    }
    
    func resetInputs() {
        sightsToSee = ""
        location = ""
        numberOfDays = ""
    }
}
