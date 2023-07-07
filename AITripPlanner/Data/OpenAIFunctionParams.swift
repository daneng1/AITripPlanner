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
                                "description": "the day and the itinterary items for each day, do not include specific dates",
                                "properties": [
                                    "day": [
                                        "type": "string",
                                        "description": "the title of the day, eg 'Day 1'",
                                        "items": [
                                            "type": "string",
                                        ]
                                    ]  as [String : Any],
                                    "dayDescription": [
                                        "type": "string",
                                        "description": "a brief description (3-5 words max length) of the daily activites",
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
                                                    "description": "a detailed description (20-30 words max length) of the specific activity suggested for the day",
                                                    "items": [
                                                        "type": "string",
                                                    ],
                                                ] as [String : Any],
                                                "activityTips": [
                                                    "type": "string",
                                                    "description": "any specific travel tips associted with the specific activity suggested for the day, 10-15 words max length",
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
