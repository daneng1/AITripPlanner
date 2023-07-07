//
//  AITripPlannerTests.swift
//  AITripPlannerTests
//
//  Created by Dan Engel on 7/6/23.
//

import XCTest
@testable import AITripPlanner

final class AITripPlannerTests: XCTestCase {

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

        let unsplashImage = APIResponseFixture.getUnsplashData()
            
            vm.unsplashImage = unsplashImage
            
            XCTAssertEqual(vm.unsplashImage, unsplashImage)
    }
    
    func test_AITripPlannerViewModel_response_EqualsInjectedValue() throws {
        let vm = PlannerViewModel(unsplashImage: nil, error: nil, response: nil)
            
        let response = APIResponseFixture.getOpenAIData()
        vm.response = response
            
            XCTAssertEqual(vm.response, response)
    }

}
