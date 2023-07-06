//
//  AITripPlannerTests.swift
//  AITripPlannerTests
//
//  Created by Dan Engel on 7/6/23.
//

import XCTest
@testable import AITripPlanner

final class AITripPlannerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_AITripPlannerViewModel_userInput_isEmpty() throws {
        let vm = PlannerViewModel(unsplashImage: nil, error: nil, response: nil)
        XCTAssertEqual(vm.sightsToSee, "")
        XCTAssertEqual(vm.location, "")
        XCTAssertEqual(vm.numberOfDays, "")
        XCTAssertEqual(vm.timeOfYear, "")
        XCTAssertEqual(vm.selectedImage, "")
    }
    
    func test_AITripPlannerViewModel_userInput_containsData() throws {
        let vm = PlannerViewModel(unsplashImage: nil, error: nil, response: nil)
        
        let sightsToSee = "Eiffel Tower, Moulin Rouge"
        let location = "Paris"
        let numberOfDays = "5"
        let timeOfYear = "Fall"
        let selectedImage = "image_09"
        
        vm.sightsToSee = sightsToSee
        vm.location = location
        vm.numberOfDays = numberOfDays
        vm.timeOfYear = timeOfYear
        vm.selectedImage = selectedImage
        
        XCTAssertEqual(vm.sightsToSee, sightsToSee)
        XCTAssertEqual(vm.location, location)
        XCTAssertEqual(vm.numberOfDays, numberOfDays)
        XCTAssertEqual(vm.timeOfYear, timeOfYear)
        XCTAssertEqual(vm.selectedImage, selectedImage)
    }
    
    func test_AITripPlannerViewModel_loading_EqualsInjectedValue_stress() throws {
        let vm = PlannerViewModel(unsplashImage: nil, error: nil, response: nil)

        for _ in 0...100 {
            let loading = Bool.random()
            
            vm.loading = loading
            
            XCTAssertEqual(vm.loading, loading)
        }
    }
    
    func test_AITripPlannerViewModel_showDetailsView_EqualsInjectedValue_stress() throws {
        let vm = PlannerViewModel(unsplashImage: nil, error: nil, response: nil)

        for _ in 0...100 {
            let showDetailsView = Bool.random()
            
            vm.showDetailsView = showDetailsView
            
            XCTAssertEqual(vm.showDetailsView, showDetailsView)
        }
    }
    
    func test_AITripPlannerViewModel_showAlert_EqualsInjectedValue_stress() throws {
        let vm = PlannerViewModel(unsplashImage: nil, error: nil, response: nil)

        for _ in 0...100 {
            let showAlert = Bool.random()
            
            vm.showAlert = showAlert
            
            XCTAssertEqual(vm.showAlert, showAlert)
        }
    }
    
    func test_AITripPlannerViewModel_unsplashImage_EqualsInjectedValue() throws {
        let vm = PlannerViewModel(unsplashImage: nil, error: nil, response: nil)

            let unsplashImage = Results(
                id: "12345",
                altDescription: "this is an alt description",
                urls: Urls(
                    small: "https://images.unsplash.com/photo-1423450822265-fcd97e52ecb5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjkwMzR8MHwxfHNlYXJjaHwxfHxEZW52ZXJ8ZW58MHwyfHx8MTY4ODU4MDk1OHww&ixlib=rb-4.0.3&q=80&w=400",
                    regular: "https://images.unsplash.com/photo-1423450822265-fcd97e52ecb5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NjkwMzR8MHwxfHNlYXJjaHwxfHxEZW52ZXJ8ZW58MHwyfHx8MTY4ODU4MDk1OHww&ixlib=rb-4.0.3&q=80&w=1080"
                )
            )
            
            vm.unsplashImage = unsplashImage
            
            XCTAssertEqual(vm.unsplashImage, unsplashImage)
    }
    
    
    func test_AITripPlannerViewModel_response_EqualsInjectedValue() throws {
        let vm = PlannerViewModel(unsplashImage: nil, error: nil, response: nil)

        let response = OpenAIFunctionResponse(
            id: "12345",
            location: "Denver",
            itinerary: [
                Day(day: "Day 1",
                    dayDescription: "Day 1",
                    itineraryItems: [
                        ItineraryItem(activity: "Visit Red Rocks Park and Amphitheater",
                                      activityDescription: "Explore the beautiful Red Rocks Park and Amphitheater, known for its stunning natural rock formations and panoramic views of Denver. You can take a hike or simply enjoy the scenery. The amphitheater also hosts concerts and events.",
                                      activityTips: "Arrive early in the morning to beat the crowd. Wear comfortable shoes for walking.",
                                      link: "https://www.redrocksonline.com/"),
                        ItineraryItem(activity: "Learn at the Denver Museum of Nature & Science",
                                      activityDescription: "Immerse yourself in the wonders of science and nature at the Denver Museum of Nature & Science. Discover fascinating exhibits, including dinosaur fossils, space exploration, and wildlife habitats. You can also catch a show at the planetarium.",
                                      activityTips: "Plan to spend a few hours at the museum as there is a lot to see. Check the museum\'s website for special exhibitions and shows.",
                                      link: "https://www.dmns.org/"),
                        ItineraryItem(activity: "Explore the Denver Botanic Gardens",
                                      activityDescription: "Escape to the tranquility of the Denver Botanic Gardens and wander through its beautiful gardens and conservatory. Admire a vast collection of plants from around the world, including exotic flowers, succulents, and water features.",
                                      activityTips: "Visit in the morning or late afternoon to avoid the heat of the day. Don\'t forget your camera!",
                                      link: "https://www.botanicgardens.org/")
                    ]
                   ),
            ]
        )
            
            vm.response = response
            
            XCTAssertEqual(vm.response, response)
    }
    

}
