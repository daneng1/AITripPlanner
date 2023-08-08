//
//  APIResponseFixture.swift
//  AITripPlanner
//
//  Created by Dan Engel on 7/6/23.
//

import Foundation

struct APIResponseFixture {
    static func getOpenAIData() -> Itinerary {
        return Itinerary(
            tripTitle: "Denver and Seattle",
            tripPlan: [
                TripPlan(
//                    id: "ijsdhf8",
                          destination: "Denver",
                          destinationItinerary: [
                            DestinationItinerary(dayTitle: "Day 1",
                                dayDescription: "Tour Denver",
                                dayItineraryItems: [
                                    ItineraryItem(activityTitle: "Visit Red Rocks Park and Amphitheater",
                                                  activityDescription: "Explore the beautiful Red Rocks Park and Amphitheater, known for its stunning natural rock formations and panoramic views of Denver. You can take a hike or simply enjoy the scenery. The amphitheater also hosts concerts and events.",
                                                  activityTips: "Arrive early in the morning to beat the crowd. Wear comfortable shoes for walking.",
                                                  link: "https://www.redrocksonline.com/"),
                                    ItineraryItem(activityTitle: "Learn at the Denver Museum of Nature & Science",
                                                  activityDescription: "Immerse yourself in the wonders of science and nature at the Denver Museum of Nature & Science. Discover fascinating exhibits, including dinosaur fossils, space exploration, and wildlife habitats. You can also catch a show at the planetarium.",
                                                  activityTips: "Plan to spend a few hours at the museum as there is a lot to see. Check the museum\'s website for special exhibitions and shows.",
                                                  link: "https://www.dmns.org/"),
                                    ItineraryItem(activityTitle: "Explore the Denver Botanic Gardens",
                                                  activityDescription: "Escape to the tranquility of the Denver Botanic Gardens and wander through its beautiful gardens and conservatory. Admire a vast collection of plants from around the world, including exotic flowers, succulents, and water features.",
                                                  activityTips: "Visit in the morning or late afternoon to avoid the heat of the day. Don\'t forget your camera!",
                                                  link: "https://www.botanicgardens.org/")
                                ]
                               ),
                          ]
                         ),
                TripPlan(
//                        id: "ijsdfgdsg",
                          destination: "Salt Lake City",
                          destinationItinerary: [
                            DestinationItinerary(dayTitle: "Day 1",
                                dayDescription: "Tour Salt Lake City",
                                dayItineraryItems: [
                                    ItineraryItem(activityTitle: "Visit Red Rocks Park and Amphitheater",
                                                  activityDescription: "Explore the beautiful Red Rocks Park and Amphitheater, known for its stunning natural rock formations and panoramic views of Denver. You can take a hike or simply enjoy the scenery. The amphitheater also hosts concerts and events.",
                                                  activityTips: "Arrive early in the morning to beat the crowd. Wear comfortable shoes for walking.",
                                                  link: "https://www.redrocksonline.com/"),
                                    ItineraryItem(activityTitle: "Learn at the Denver Museum of Nature & Science",
                                                  activityDescription: "Immerse yourself in the wonders of science and nature at the Denver Museum of Nature & Science. Discover fascinating exhibits, including dinosaur fossils, space exploration, and wildlife habitats. You can also catch a show at the planetarium.",
                                                  activityTips: "Plan to spend a few hours at the museum as there is a lot to see. Check the museum\'s website for special exhibitions and shows.",
                                                  link: "https://www.dmns.org/"),
                                    ItineraryItem(activityTitle: "Explore the Denver Botanic Gardens",
                                                  activityDescription: "Escape to the tranquility of the Denver Botanic Gardens and wander through its beautiful gardens and conservatory. Admire a vast collection of plants from around the world, including exotic flowers, succulents, and water features.",
                                                  activityTips: "Visit in the morning or late afternoon to avoid the heat of the day. Don\'t forget your camera!",
                                                  link: "https://www.botanicgardens.org/")
                                ]
                               ),
                          ]
                         ),
            ]
        )
    }
    
    static func getUnsplashData() -> [Photo] {
        return [
            Photo(
                id: "12345",
                altDescription: "this is an alt description",
                urls: Urls(
                    small: "https://images.unsplash.com/photo-1423450822265-fcd97e52ecb5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjkwMzR8MHwxfHNlYXJjaHwxfHxEZW52ZXJ8ZW58MHwyfHx8MTY4ODU4MDk1OHww&ixlib=rb-4.0.3&q=80&w=400",
                    regular: "https://images.unsplash.com/photo-1423450822265-fcd97e52ecb5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjkwMzR8MHwxfHNlYXJjaHwxfHxEZW52ZXJ8ZW58MHwyfHx8MTY4ODU4MDk1OHww&ixlib=rb-4.0.3&q=80&w=1080"
                )
            ),
        ]
    }
    
}
