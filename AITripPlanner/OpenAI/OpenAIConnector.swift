//
//  OpenAIConnector.swift
//  AITripPlanner
//
//  Created by Dan Engel on 6/20/23.
//

import Foundation
import Combine

class OpenAIConnector: ObservableObject {
    
    let openAIURL = URL(string: "https://api.openai.com/v1/chat/completions")
    
    @Published var messageLog: [[String: String]] = [
        ["role": "system", "content": "You're a sassy, funny assistant"]
    ]
    
    func fetchOpenAIData(completion: @escaping (Result<Itinerary, Error>) -> Void) {
        guard let openAIKey = Secrets.openAIKey else { return completion(.failure(NSError(domain: "", code: -1, userInfo: ["description": "Error"]))) }

                var request = URLRequest(url: self.openAIURL!)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("Bearer \(openAIKey)", forHTTPHeaderField: "Authorization")
                
                let httpBody: [String: Any] = [
                    "model": "gpt-4-0613",
                    "messages": self.messageLog,
                    "functions": OpenAIFunctionParams.getParams(),
                    "function_call": "auto",
                    "temperature": 0.2,
                ]
                
                print("BODY ******* \(httpBody)")
                
                do {
                    let httpBodyJson = try JSONSerialization.data(withJSONObject: httpBody, options: .prettyPrinted)
                    request.httpBody = httpBodyJson
                } catch {
                    print("Unable to convert to JSON \(error)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    self.logMessage("error", messageUserType: .assistant)
                }
                
                let config = URLSessionConfiguration.default
                config.timeoutIntervalForRequest = 240.0
                
                let session = URLSession(configuration: config)
                
                let task = session.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print("Error: \(error)")
                        completion(.failure(error))
                    } else if let data = data {
                        let jsonStr = String(data: data, encoding: .utf8)!
                        let responseHandler = OpenAIResponseHandler()
                        if let responseData = responseHandler.decodeJson(jsonString: jsonStr) {
                            if let message = responseData.choices.first?.message.function_call.arguments {
                                do {
                                    let response = try responseHandler.decodeArgumentsJson(jsonString: message)
                                    DispatchQueue.main.async {
                                        print(response)
                                        completion(.success(response))
                                    }
                                } catch {
                                    DispatchQueue.main.async {
                                        completion(.failure(error))
                                    }
                                }
                            } else {
                                let error = NSError(domain: "", code: -1, userInfo: ["description": "Unable to parse response"])
                                DispatchQueue.main.async {
                                    completion(.failure(error))
                                }
                            }
                        }
                    }
                }
                task.resume()
    }
}

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
            
            semaphore.signal()
        })
        task.resume()
        
        let timeout = DispatchTime.now() + .seconds(30)
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

