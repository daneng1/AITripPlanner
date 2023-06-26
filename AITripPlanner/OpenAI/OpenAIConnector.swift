//
//  OpenAIConnector.swift
//  AITripPlanner
//
//  Created by Dan Engel on 6/20/23.
//

import Foundation
import Combine

class OpenAIConnector: ObservableObject {
//    @Published var sightsToSee = "space needle"
//    @Published var location = "seattle"
//    @Published var numberOfDays = "3"
//    @Published var response = ""
//    @Published var timeOfYear = "fall"
//    @Published var loading: Bool = false
    
    let openAIURL = URL(string: "https://api.openai.com/v1/chat/completions")
    
    @Published var messageLog: [[String: String]] = [
        ["role": "system", "content": "You're a friendly, helpful assistant"]
    ]
    
    func getAPIKey(for key: String) -> String? {
        return ProcessInfo.processInfo.environment[key]
    }
    
//    func buildQuery() {
//        loading = true
//        let message = "Can you give me an itinerary for a trip to \(location), that lasts \(numberOfDays) in \(timeOfYear) and I'd like to see or experience \(sightsToSee)? Please provide links to any sights you recommend, consider the local holidays, crowds and the best time of the day to visit each site. Please place line break before each link."
//        logMessage(message, messageUserType: .user)
//        sendToAssistant()
//    }

    func sendToAssistant(completion: @escaping (Result<String, Error>) -> Void) {
        var request = URLRequest(url: self.openAIURL!)

        if let openAIKey = getAPIKey(for: "OPENAI_API_KEY") {
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(openAIKey)", forHTTPHeaderField: "Authorization")
        } else {
            print("there was an error with your API key")
            completion(.failure(NSError(domain: "", code: -1, userInfo: ["description": "There was an error with your API key"])))
            return
        }
        
        let httpBody: [String: Any] = [
            "model" : "gpt-3.5-turbo",
            "messages" : messageLog
        ]

        do {
            let httpBodyJson = try JSONSerialization.data(withJSONObject: httpBody, options: .prettyPrinted)
            request.httpBody = httpBodyJson
        } catch {
            print("Unable to convert to JSON \(error)")
            completion(.failure(error))
            logMessage("error", messageUserType: .assistant)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(.failure(error))
            } else if let data = data {
                let jsonStr = String(data: data, encoding: .utf8)!
                let responseHandler = OpenAIResponseHandler()
                if let responseData = (responseHandler.decodeJson(jsonString: jsonStr)?.choices[0].message["content"]) {
                    completion(.success(responseData))
                } else {
                    let error = NSError(domain: "", code: -1, userInfo: ["description": "Unable to parse response"])
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}


extension Dictionary: Identifiable { public var id: UUID { UUID() } }
extension Array: Identifiable { public var id: UUID { UUID() } }
extension String: Identifiable { public var id: UUID { UUID() } }

extension OpenAIConnector {
    private func executeRequest(request: URLRequest, withSessionConfig sessionConfig: URLSessionConfiguration?) -> Data? {
        let semaphore = DispatchSemaphore(value: 0)
        let session: URLSession
        if (sessionConfig != nil) {
            session = URLSession(configuration: sessionConfig!)
        } else {
            session = URLSession.shared
        }
        var requestData: Data?
        let task = session.dataTask(with: request as URLRequest, completionHandler:{ (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error != nil {
                print("error: \(error!.localizedDescription): \(error!.localizedDescription)")
            } else if data != nil {
                requestData = data
            }
            
            print("Semaphore signalled")
            semaphore.signal()
        })
        task.resume()
        
        let timeout = DispatchTime.now() + .seconds(20)
        print("Waiting for semaphore signal")
        let retVal = semaphore.wait(timeout: timeout)
        print("Done waiting, obtained - \(retVal)")
        return requestData
    }
}

extension OpenAIConnector {
    func logMessage(_ message: String, messageUserType: MessageUserType) {
        var messageUserTypeString = ""
        switch messageUserType {
        case .user:
            messageUserTypeString = "user"
        case .assistant:
            messageUserTypeString = "assistant"
        }
        
        messageLog.append(["role": messageUserTypeString, "content": message])
    }
    
    enum MessageUserType {
        case user
        case assistant
    }
}

