//
//  ContentView.swift
//  AITripPlanner
//
//  Created by Dan Engel on 6/20/23.
//

import SwiftUI
import Combine

struct DestinationFormView: View {
    @EnvironmentObject var viewModel: PlannerViewModel
    @EnvironmentObject var connector: OpenAIConnector
    @State private var inputIsPresented = false
    @State private var showDetailView: Bool = false
    let backgroundColor = Color("b")
    
    let destinations = [
        Destination(name: "Seattle", sightsToSee: "space needle", numberOfDays: "1"),
        Destination(name: "Portland", sightsToSee: "breweries, rose garden, mount hood, trailblazers ", numberOfDays: "5")
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image(viewModel.selectedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: UIScreen.main.bounds.width)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.3)
                VStack(alignment: .center) {
                    TripDestinationHeaderView(inputIsPresented: $inputIsPresented)
                        .font(.title)
                        .bold()
                        .frame(height: 50)
                        .padding(.horizontal)
                        .cornerRadius(10)
                        .padding(.top, 40)
                    List {
                        ForEach(viewModel.destinations, id: \.self) { destination in
                            Text(destinationInputText(destination: destination))
                                .padding(.horizontal)
                                .font(.body)
                                .foregroundColor(Color("secondary2"))
                        }
                        .onDelete { index in
                            viewModel.deleteDestination(at: index)
                        }
                        .listRowBackground(
                            Rectangle()
                                .fill(Color("background").opacity(0.8))
                                .cornerRadius(10)
                                .padding(.vertical, 2)
                        )
                        .listRowSeparator(.hidden)
                    }
                    .headerProminence(.increased)
                    .scrollContentBackground(.hidden)
                    if viewModel.destinations.count > 0 {
                        NavigationLink {
                            TripResultsView()
                        } label: {
                            SubmitButtonView(text: "Let's go!!")
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $inputIsPresented) {
            DestinationInputView()
        }
    }
    
    func destinationInputText(destination: Destination) -> String {
        let days = destination.numberOfDays == "1" ? "day" : "days"
        if destination.sightsToSee == "" {
            return "\(destination.name) - \(destination.numberOfDays) \(days)"
        } else {
            return "\(destination.name) - \(destination.numberOfDays) \(days), \(destination.sightsToSee)"
        }
    }
}

struct TripDestinationHeaderView: View {
    @Binding var inputIsPresented: Bool
    var body: some View {
        HStack {
            Text("Trip Destinations")
                .foregroundColor(Color("secondary2"))
            Spacer()
            Button {
                withAnimation(.spring(response: 0.2)) {
                    inputIsPresented.toggle()
                }
            } label: {
                AddItemButtonView()
            }
        }
    }
}

struct DestinationInputView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: PlannerViewModel
    
    var body: some View {
        VStack {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Where do you want to go?")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color("secondary2"))
                        TextField("", text: $viewModel.location)
                            .padding(8)
                            .background(RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 0.5))
                            .background(Color("background"))
                            .cornerRadius(10)
                        Text("For how many days?")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color("secondary2"))
                            .padding(.top, 10)
                        TextField("", text: $viewModel.numberOfDays)
                            .padding(8)
                            .background(RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 0.5))
                            .background(Color("background"))
                            .cornerRadius(10)
                            .padding(0)
                        Text("Any specific sights or activities?")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color("secondary2"))
                            .padding(.top, 10)
                        TextField("", text: $viewModel.sightsToSee)
                            .padding(8)
                            .background(RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 0.5))
                            .background(Color("background"))
                            .cornerRadius(10)
                        VStack(alignment: .center) {
                            SubmitButtonView(text: "Add destination")
                                .onTapGesture {
                                    viewModel.addDestination()
                                    if !viewModel.showAlert {
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                }
                        }
                        .padding(.vertical)
                    }
                }
                if !viewModel.suggestions.isEmpty {
                    List(viewModel.suggestions, id: \.self) { suggestion in
                        Text(suggestion.title)
                            .onTapGesture {
                                viewModel.setLocation(location: suggestion.title)
                            }
                    }
                    .scrollContentBackground(.hidden)
                    .padding(.top, 48)
                    .shadow(radius: 10)
                }
            }
        }
        .padding(.top, 40)
        .padding()
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Ooops, there was an issue"), message: Text("it looks like you may not have entered anything in one or more fields."))
        }
        .onReceive(viewModel.$location) { input in
            viewModel.completer.queryFragment = input
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationFormView()
            .environmentObject(PlannerViewModel(unsplashImage: nil, error: nil, response: nil))
            .environmentObject(OpenAIConnector())
    }
}

