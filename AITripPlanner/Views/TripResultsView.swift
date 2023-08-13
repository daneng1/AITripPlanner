//
//  TripResultsView.swift
//  AITripPlanner
//
//  Created by Dan Engel on 6/23/23.
//

import SwiftUI

struct TripResultsView: View {
    @EnvironmentObject var viewModel: PlannerViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
            VStack {
                if viewModel.error != nil {
                    ZStack {
                        Image(viewModel.selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: UIScreen.main.bounds.width)
                            .edgesIgnoringSafeArea(.all)
                            .opacity(0.2)
                        ErrorView()
                    }
                } else if viewModel.loading {
                    ZStack {
                        Image(viewModel.selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: UIScreen.main.bounds.width)
                            .edgesIgnoringSafeArea(.all)
                            .opacity(0.2)
                        LoaderView()
                    }
                } else {
                    TripResultsListView()
                }
            }
            .frame(maxHeight: UIScreen.main.bounds.height)
            .onAppear {
                viewModel.fetchItinerary()
        }
    }
}

struct TripResultsListView: View {
    @EnvironmentObject var viewModel: PlannerViewModel
    let data = APIResponseFixture.getOpenAIData()
    var body: some View {
        NavigationStack {
            VStack {
                Text(viewModel.response?.tripTitle ?? "Trip itinerary")
                    .font(.headline)
                    .foregroundColor(Color("secondary2"))
                List {
                    if let tripPlan = viewModel.response?.tripPlan {
                        ForEach(tripPlan, id: \.self) { destination in
//                            NavigationLink(destination.locationName, value: destination)
                            NavigationLink(destination: DestinationView(destination: destination)) {
                                Text(destination.locationName)
                            }
                        }
                        .listRowBackground(
                            Rectangle()
                                .fill(Color("background").opacity(0.8))
                                .cornerRadius(10)
                                .padding(.vertical, 2)
                        )
                        .listRowSeparator(.hidden)
                    }
                }
                .scrollContentBackground(.hidden)
                .frame(maxWidth: 600)
            }
            .frame(maxHeight: UIScreen.main.bounds.height)
//            .navigationDestination(for: TripPlan.self) { destination in
//                DestinationView(destination: destination)
//            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TripResultsView_Previews: PreviewProvider {
    static var previews: some View {
        TripResultsView()
            .environmentObject(PlannerViewModel(error: nil, response: APIResponseFixture.getOpenAIData()))
            .environmentObject(OpenAIConnector())
    }
}
