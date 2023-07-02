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
    @Published var unsplashImage: Results?
    @Published var showAlert: Bool = false
    private var connector = OpenAIConnector()
    
    init(unsplashImage: Results?, error: Error?, response: OpenAIFunctionResponse?) {
        self.unsplashImage = unsplashImage
        self.error = error
        self.response = response
    }
    
    func buildQuery() {
        self.loading = true
        let message = "Can you give me an itinerary for a trip to \(location), that lasts \(numberOfDays) in \(timeOfYear) and I'd like to see or experience \(sightsToSee)? Please provide links to any sights you recommend, consider the local holidays, crowds and the best time of the day to visit each site. The response should be formatted for SwiftUI."
        connector.logMessage(message, messageUserType: .user)
        fetchPhoto() { result in
            switch result {
            case .success(let response):
                self.unsplashImage = response.results[0]
                print("First photo ID: \(response.results.first?.id ?? "")")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
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
    
    func getAPIKey(for key: String) -> String? {
        return ProcessInfo.processInfo.environment[key]
    }

    func fetchPhoto(completion: @escaping (Result<UnSplashAPIResponse, Error>) -> Void) {
        let urlString = URL(string: "https://api.unsplash.com/search/photos?query=\(location)&orientation=squarish&per_page=1")
        var request = URLRequest(url: urlString!)
        if let unsplashAPIKry = getAPIKey(for: "UNSPLASH_ACCESS_KEY") {
            request.addValue(unsplashAPIKry, forHTTPHeaderField: "client-id")
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                // Handle data error
                return
            }
            do {
                let decoder = JSONDecoder()
                let photoResponse = try decoder.decode(UnSplashAPIResponse.self, from: data)
                print(photoResponse)
                completion(.success(photoResponse))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
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
}
