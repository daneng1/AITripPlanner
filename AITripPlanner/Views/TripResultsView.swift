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
        }
        .onAppear {
            viewModel.buildQuery()
        }
    }
}

struct TripResultsListView: View {
    @EnvironmentObject var viewModel: PlannerViewModel
    let data = APIResponseFixture.getOpenAIData()
    var body: some View {
        List {
            if let destinations = viewModel.response?.tripPlan {
                ForEach(destinations, id: \.self) { destination in
                    NavigationLink(destination: DestinationView()) {
                        Text(destination.destination)
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
    }
}

struct TripResultsView_Previews: PreviewProvider {
    static var previews: some View {
        TripResultsView()
            .environmentObject(PlannerViewModel(unsplashImage: nil, error: nil, response: APIResponseFixture.getOpenAIData()))
            .environmentObject(OpenAIConnector())
    }
}
