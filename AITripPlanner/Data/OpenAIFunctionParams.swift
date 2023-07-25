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
                "description": "Get a trip itinery based on a destination or multiple destinations and a duration of days",
                "parameters": [
                    "type": "object",
                    "properties": [
                        "tripTitle": [
                            "type": "string",
                            "description": "list all of the destinations, ie 'Denver, Seattle, and Boise'",
                        ] as [String : Any],
                        "tripPlan": [
                            "type": "array",
                            "description": "the itinerary for all destinations, separated by destination",
                            "items": [
                                "type": "object",
                                "properties": [
                                    "id": [
                                        "type": "string",
                                        "description": "a unique ID for each destination. This should be 16 characters in length and should be randomized",
                                    ] as [String : Any],
                                    "destination": [
                                        "type": "string",
                                        "description": "the name of the destination the user wants to visit",
                                    ] as [String : Any],
                                    "destinationItinerary": [
                                        "type": "array",
                                        "description": "this is the whole itinerary you are suggesting for each destination",
                                        "items": [
                                            "type": "object",
                                            "description": "the day and the itinerary items for each day, NEVER include specific dates",
                                            "properties": [
                                                "dayTitle": [
                                                    "type": "string",
                                                    "description": "This is the title of the day. This should always be formatted as 'Day 1', 'Day 2', etc.",
                                                    "items": [
                                                        "type": "string",
                                                    ]
                                                ]  as [String : Any],
                                                "dayDescription": [
                                                    "type": "string",
                                                    "description": "This should always be a brief description (3-5 words max length) of the daily activites, like a newspaper headline.",
                                                    "items": [
                                                        "type": "string",
                                                    ]
                                                ]  as [String : Any],
                                                "dayItineraryItems": [
                                                    "type": "array",
                                                    "description": "the itinerary items for this specific day",
                                                    "items": [
                                                        "type": "object",
                                                        "description": "each suggestion for the day, including any hyperlinks",
                                                        "properties": [
                                                            "activityTitle": [
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
                            ] as [String : Any],
                        ]
                    ],
                    "required": ["id", "tripTitle", "tripPlan"],
                ] as [String : Any]
            ],
        ]
    }
}
