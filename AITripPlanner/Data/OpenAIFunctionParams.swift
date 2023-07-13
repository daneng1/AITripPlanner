//
//  OpenAIFunctionParams.swift
//  AITripPlanner
//
//  Created by Dan Engel on 7/7/23.
//

import Foundation

struct OpenAIFunctionParams {
    static func getParams() -> [[String: Any]] {
        return [
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
                                "description": "the day and the itinterary items for each day, NEVER include specific dates",
                                "properties": [
                                    "day": [
                                        "type": "string",
                                        "description": "the title of the day. This should always be formatted as 'Day 1', 'Day 2', etc.",
                                        "items": [
                                            "type": "string",
                                        ]
                                    ]  as [String : Any],
                                    "dayDescription": [
                                        "type": "string",
                                        "description": "This should alsways be a brief description (3-5 words max length) of the daily activites, like a newspaper headline.",
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
                                                    "description": "a headline of the specific activity suggested for the day, 3-5 words max length",
                                                    "items": [
                                                        "type": "string",
                                                    ],
                                                ] as [String : Any],
                                                "activityDescription": [
                                                    "type": "string",
                                                    "description": "a detailed description (30 words minimum length, 100 words max length) of the specific activity suggested for the day. This can be verbose and should be an exciting desctiption of the activity.",
                                                    "items": [
                                                        "type": "string",
                                                    ],
                                                ] as [String : Any],
                                                "activityTips": [
                                                    "type": "string",
                                                    "description": "any specific travel tips associted with the specific activity suggested for the day, 10-15 words max length. The tone should sound like the user is getting insider tips from a local",
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
                            ] as [String : Any]
                        ]
                    ],
                    "required": ["itinerary", "location", "id"],
                ] as [String : Any]
            ],
        ]
    }
}
