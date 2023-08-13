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
    @State private var alertIsPresented = false
    @State private var showDetailView: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .center) {
                    TripDestinationHeaderView(inputIsPresented: $inputIsPresented)
                        .font(.title)
                        .bold()
                        .frame(height: 50)
                        .frame(maxWidth: 600)
                        .padding(.horizontal)
                        .cornerRadius(10)
                        .padding(.top, 40)
                    if !viewModel.destinations.isEmpty {
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
                        .frame(maxWidth: 600)
                        .scrollContentBackground(.hidden)
                    } else {
                        Spacer()
                    }
                    if viewModel.destinations.count > 0 {
                        Button {
                            withAnimation(.spring(response: 0.2)) {
                                alertIsPresented.toggle()
                            }
                        } label: {
                            DeleteItemView()
                        }
                        .accessibilityLabel("delete trip")
                        .accessibilityHint("delete all destinations you've added")
                    }
                    if viewModel.destinations.count > 0 {
                        NavigationLink {
                            TripResultsView()
                        } label: {
                            SubmitButtonView(text: "Let's go!!")
                                .frame(maxWidth: 300)
                                .padding(.bottom, 32)
                                .accessibilityLabel("submit trip")
                        }
                    }
                }
            }
            .frame(maxHeight: UIScreen.main.bounds.height)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationTitle("Destinations")
        .sheet(isPresented: $inputIsPresented) {
            DestinationInputView()
        }
        .alert(isPresented: $alertIsPresented) {
            Alert(
                title: Text("Delete itinerary"),
                primaryButton: .destructive(Text("Delete")) {
                    viewModel.deleteItinerary()
                },
                secondaryButton: .cancel()
            )
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
            .accessibilityLabel("Add destination")
            .accessibilityHint("open a form to add a new destination")
        }
        .padding(.horizontal)
    }
}

struct DestinationInputView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: PlannerViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    ZStack {
                        Circle()
                            .foregroundColor(Color("background"))
                            .frame(width: 30)
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color("text"))
                            .frame(width: 30)
                    }
                }
                .accessibilityLabel("Dismiss form")
                .accessibilityHint("Close the form without adding a destination")
            }
            .padding(.bottom, 8)
            ZStack {
                ScrollView {
                    inputView
                }
            }
        }
        .padding()
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Ooops, there was an issue"), message: Text("it looks like you may not have entered anything in one or more fields."))
        }
    }
}

extension DestinationInputView {
    var inputView: some View {
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
                    .accessibilityLabel("Add destination button")
            }
            .padding(.vertical)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationFormView()
            .environmentObject(PlannerViewModel(error: nil, response: nil))
            .environmentObject(OpenAIConnector())
    }
}

