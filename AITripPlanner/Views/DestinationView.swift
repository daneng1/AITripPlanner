//
//  DestinationView.swift
//  AITripPlanner
//
//  Created by Dan Engel on 7/25/23.
//

import SwiftUI
import URLImageModule

struct DestinationView: View {
    @EnvironmentObject var viewModel: PlannerViewModel
    var destination: TripPlan
    
    var body: some View {
        VStack {
            if viewModel.loading {
                LoaderView()
            } else {
                VStack {
                    VStack {
                        if let photo = viewModel.unsplashImage.first(where: { destination.locationName == $0.0 }) {
                            URLImage(url: URL(string: photo.1.urls.regular)!) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .accessibility(label: Text(photo.1.altDescription))
                            }
                        } else {
                            Image(systemName: "image_09")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 300)
                                .ignoresSafeArea(.all)
                                .accessibility(label: Text("An image of the Eiffel Tower"))
                        }
                    }
                    VStack {
                        Text("Here's your itinerary for \(destination.locationName)!")
                            .font(.headline)
                            .foregroundColor(Color("secondary2"))
                        ScrollView {
                            ForEach(destination.destinationItinerary, id: \.dayTitle) { day in
                                DayItineraryView(dailyDetails: day)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .frame(maxHeight: UIScreen.main.bounds.height)
        .onAppear {
            viewModel.fetchPhoto(destination: destination.locationName)
        }
    }
}

struct DestinationView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationView(destination: APIResponseFixture.getOpenAIData().tripPlan[0])
            .environmentObject(PlannerViewModel(error: nil, response: nil))

    }
}
