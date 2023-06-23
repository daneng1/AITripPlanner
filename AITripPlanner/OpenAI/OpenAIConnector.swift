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

    func sendToAssistant() -> String {
        var request = URLRequest(url: self.openAIURL!)
        var response: String = ""
        if let openAIKey = getAPIKey(for: "OPENAI_API_KEY") {
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(openAIKey)", forHTTPHeaderField: "Authorization")
        } else {
            print("there was an error with your API key")
        }
        
        let httpBody: [String: Any] = [
            "model" : "gpt-3.5-turbo",
            "messages" : messageLog
        ]
        
        var httpBodyJson: Data? = nil

        do {
            httpBodyJson = try JSONSerialization.data(withJSONObject: httpBody, options: .prettyPrinted)
        } catch {
            print("Unable to convert to JSON \(error)")
            logMessage("error", messageUserType: .assistant)
        }
        
        request.httpBody = httpBodyJson
        
        if let requestData = executeRequest(request: request, withSessionConfig: nil) {
            let jsonStr = String(data: requestData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
            let responseHandler = OpenAIResponseHandler()
            logMessage((responseHandler.decodeJson(jsonString: jsonStr)?.choices[0].message["content"])!, messageUserType: .assistant)
            response = (responseHandler.decodeJson(jsonString: jsonStr)?.choices[0].message["content"])!
            print("\(response)")
        }
        return response
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

