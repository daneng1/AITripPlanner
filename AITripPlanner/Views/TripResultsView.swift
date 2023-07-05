//
//  TripResultsView.swift
//  AITripPlanner
//
//  Created by Dan Engel on 6/23/23.
//

import SwiftUI
import URLImage

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
                        viewModel.unsplashImage != "" ?
                        URLImage(url: URL(string: viewModel.unsplashImage?.urls.regular)!) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } :
                        Image(systemName: "image_09.jpg")
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
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
    }
}
