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
        ["role": "system", "content": "You're a friendly, helpful assistant"]
    ]
    
    func getAPIKey(for key: String) -> String? {
        return ProcessInfo.processInfo.environment[key]
    }

    func sendToAssistant(completion: @escaping (Result<OpenAIFunctionResponse, Error>) -> Void) {
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
        
        let openAIFunction: [[String: Any]] = [
            [
                "name": "get_trip_itinerary",
                "description": "get a trip itinery based on a location, a time of year for travel and a duration of days",
                "parameters": [
                    "type": "object",
                    "properties": [
                        "id": [
                            "type": "string",
                            "description": "create a unique ID for this itinerary",
                        ] as [String : Any],
                        "location": [
                            "type": "string",
                            "description": "the city or region the user wants to visit",
                        ] as [String : Any],
                        "itinerary": [
                            "type": "array",
                            "description": "the suggested itinerary",
                            "items": [
                                "type": "object",
                                "description": "the day and the items for each day, do not include specific dates",
                                "properties": [
                                    "day": [
                                        "type": "string",
                                        "description": "the title of the day",
                                        "items": [
                                            "type": "string",
                                        ]
                                    ]  as [String : Any],
                                    "dayDescription": [
                                        "type": "string",
                                        "description": "a brief description of the daily activites",
                                        "items": [
                                            "type": "string",
                                        ]
                                    ]  as [String : Any],
                                    "itineraryItems": [
                                        "type": "array",
                                        "description": "the itinerary items for this specific day",
                                        "items": [
                                            "type": "object",
                                            "description": "each suggestion for the day, including any hyperlinks",
                                            "properties": [
                                                "activity": [
                                                    "type": "string",
                                                    "description": "a headline of the specific activity suggested for the day",
                                                    "items": [
                                                        "type": "string",
                                                    ],
                                                ] as [String : Any],
                                                "activityDescription": [
                                                    "type": "string",
                                                    "description": "a detailed description of the specific activity suggested for the day",
                                                    "items": [
                                                        "type": "string",
                                                    ],
                                                ] as [String : Any],
                                                "activityTips": [
                                                    "type": "string",
                                                    "description": "any specific travel tips associted with the specific activity suggested for the day",
                                                    "items": [
                                                        "type": "string",
                                                    ],
                                                ] as [String : Any],
                                                "link": [
                                                    "type": "string",
                                                    "description": "optional, any hyperlinks associated with the specific activity",
                                                    "items": [
                                                        "type": "string",
                                                    ]
                                                ] as [String : Any]
                                            ] as [String : Any],
                                        ]  as [String : Any]
                                    ]  as [String : Any]
                                ] as [String : Any]
                            ]
                        ]
                    ],
                    "required": ["itinerary", "location", "id"],
                ]
            ],
        ]
        
        let httpBody: [String: Any] = [
            "model": "gpt-3.5-turbo-0613",
            "messages": messageLog,
            "functions": openAIFunction,
            "function_call": "auto",
        ]

        do {
            let httpBodyJson = try JSONSerialization.data(withJSONObject: httpBody, options: .prettyPrinted)
            request.httpBody = httpBodyJson
        } catch {
            print("Unable to convert to JSON \(error)")
            DispatchQueue.main.async {
                completion(.failure(error))
            }
            logMessage("error", messageUserType: .assistant)
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                completion(.failure(error))
            } else if let data = data {
                let jsonStr = String(data: data, encoding: .utf8)!
                let responseHandler = OpenAIResponseHandler()
                if let responseData = (responseHandler.decodeJson(jsonString: jsonStr)) {
                    if let args = responseHandler.decodeArgumentsJson(jsonString: responseData.choices[0].message.function_call.arguments) {
                        DispatchQueue.main.async {
                            completion(.success(args))
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

