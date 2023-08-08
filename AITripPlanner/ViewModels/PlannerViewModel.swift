//
//  PlannerViewModel.swift
//  AITripPlanner
//
//  Created by Dan Engel on 6/23/23.
//

import Foundation

class PlannerViewModel: ObservableObject {
    
    @Published var sightsToSee = ""
    @Published var location = ""
    @Published var numberOfDays = ""
    @Published var response: OpenAIFunctionResponse?
    @Published var error: Error?
    @Published var timeOfYear = ""
    @Published var loading: Bool = false
    @Published var showDetailsView: Bool = false
    @Published var selectedImage: String = ""
    @Published var unsplashImage: Photo?
    @Published var showAlert: Bool = false
    private var connector = OpenAIConnector()
    private var travailAPI = TravailAPI()
    
    init(unsplashImage: Photo?, error: Error?, response: OpenAIFunctionResponse?) {
        self.unsplashImage = unsplashImage
        self.error = error
        self.response = response
    }
    
    
    func buildQuery() {
        if sightsToSee == "" {
            sightsToSee = "the top tourist sights"
        }
        self.loading = true
        let message = "Please give me an itinerary for a trip to \(location), that lasts \(numberOfDays) days during \(timeOfYear) and I'd like to see or experience \(sightsToSee). Please provide links to any sights you recommend, consider the local holidays, crowds and the best time of the day to visit each site. Do not include specific dates for travel, just the time of year requested."
        connector.logMessage(message, messageUserType: .user)
        
        fetchPhoto { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.unsplashImage = response.results[0]
                case .failure(let error):
                    print("Unsplash Error: \(error)")
                }
            }
        }
        connector.fetchOpenAIData { (result) in
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

    func fetchPhoto(completion: @escaping (Result<UnSplashAPIResponse, Error>) -> Void) {
        let locationNoSpaces = location.replacingOccurrences(of: " ", with: "%20")
        let urlString = URL(string: "https://api.unsplash.com/search/photos?query=\(locationNoSpaces)%20popular%20tourist%20destination&orientation=landscape&per_page=1")
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
        if timeOfYear == "" {
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
        error = nil
        unsplashImage = nil
    }
}
