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
                    ErrorView()
                } else if viewModel.loading {
                    LoaderView()
                } else {
                    TripResultsListView()
                }
            }
//            VStack {
//                if viewModel.error != nil {
//                    ErrorView()
//                } else if viewModel.response != nil {
//                    VStack {
//                        if let url = viewModel.unsplashImage?.urls.regular {
//                            URLImage(url: URL(string: url)!) { image in
//                                image
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .accessibility(label: Text(viewModel.unsplashImage?.altDescription ?? "A travel image"))
//
//                            }
//                        } else {
//                            Image(systemName: "image_09")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(maxHeight: 300)
//                                .ignoresSafeArea(.all)
//                                .accessibility(label: Text("An image of the Eiffel Tower"))
//                        }
//                        VStack {
//                            Text("Here's your itinerary for \(viewModel.location)!")
//                                .font(.headline)
//                                .foregroundColor(Color("secondary2"))
//                        }
//                        .padding()
//                    }
//                } else {
//                    LoaderView()
//                }
//            }
        }
        .onAppear {
            viewModel.buildQuery()
        }
        .onDisappear {
            viewModel.resetError()
        }
    }
}

struct TripResultsListView: View {
    @EnvironmentObject var viewModel: PlannerViewModel
    var body: some View {
        List {
            if let destinations = viewModel.response?.tripPlan {
                ForEach(destinations, id: \.self) { destination in
                    Text(destination.destination)
                }
            }
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
