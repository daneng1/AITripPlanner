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
    var body: some View {
        VStack {
            if viewModel.error != nil {
                ErrorView()
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
                    VStack {
                        Text("Here's your itinerary for \(viewModel.location)!")
                            .font(.headline)
                            .foregroundColor(Color("secondary2"))
                    }
                    .padding()
                }
            } else {
                LoaderView()
            }
        }
//        onAppear {
//            viewModel.
//        }
    }
}

struct DestinationView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationView()
    }
}
