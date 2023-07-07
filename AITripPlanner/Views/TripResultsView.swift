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
                                    .accessibility(label: Text(viewModel.unsplashImage?.altDescription ?? "A travel image"))

                            }
                        } else {
                            Image(systemName: "image_09")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 300)
                                .ignoresSafeArea(.all)
                                .accessibility(label: Text("An image of the Eiffel Tower"))
                        }
                        ScrollView {
                            Text("Here's your itinerary for \(viewModel.location)!")
                                .font(.headline)
                                .foregroundColor(Color("secondary2"))
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
            .environmentObject(PlannerViewModel(unsplashImage: nil, error: nil, response: APIResponseFixture.getOpenAIData()))
            .environmentObject(OpenAIConnector())
    }
}
