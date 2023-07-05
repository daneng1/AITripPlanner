//
//  TripResultsView.swift
//  AITripPlanner
//
//  Created by Dan Engel on 6/23/23.
//

import SwiftUI
import URLImageModule

struct TripResultsView: View {
    @EnvironmentObject var viewModel: PlannerViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            Image(viewModel.selectedImage)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: UIScreen.main.bounds.width)
                .edgesIgnoringSafeArea(.all)
                .opacity(0.2)
            VStack {
                if viewModel.error != nil {
                    Text(viewModel.error?.localizedDescription ?? "Sorry there was an error")
                } else if viewModel.response != nil {
                    VStack {
                        if let url = viewModel.unsplashImage?.urls.regular {
                            URLImage(url: URL(string: url)!) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                        } else {
                            Image(systemName: "image_09")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 300)
                                .ignoresSafeArea(.all)
                        }
                        ScrollView {
                            if let itinerary = viewModel.response?.itinerary {
                                ForEach(itinerary, id: \.self) { day in
                                    DayItineraryView(dailyDetails: day)
                                }
                            }
                        }
                        .padding()
                    }
                } else {
                    LoaderView()
                }
            }
        }
        .onAppear {
            viewModel.buildQuery()
        }
    }
}

struct TripResultsView_Previews: PreviewProvider {
    static var previews: some View {
        TripResultsView()
            .environmentObject(PlannerViewModel(unsplashImage: nil, error: nil, response: previewData))
            .environmentObject(OpenAIConnector())
    }
}

let previewData = OpenAIFunctionResponse(
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
