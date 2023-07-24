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
                    HStack {
                        Text("My Destinations")
                            .foregroundColor(Color("secondary2"))
                            .font(.title)
                        Spacer()
                        Button {
                            withAnimation(.spring(response: 0.2)) {
                                inputIsPresented.toggle()
                            }
                        } label: {
                            ZStack {
                                Circle()
                                    .foregroundColor(Color("secondary1"))
                                    .frame(width: 40)
                                Image(systemName: "plus")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color("primary"))
                                    .frame(width: 25)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .padding(.horizontal)
                    .background(Color("background"))
                    .cornerRadius(10)
                    if viewModel.destinations.count > 0 {
                        List {
                            ForEach(viewModel.destinations, id: \.self) { destination in
                                if destination.sightsToSee == "" {
                                    Text("\(destination.name), \(destination.numberOfDays) days")
                                } else {
                                    Text("\(destination.name), \(destination.numberOfDays) days, \(destination.sightsToSee)")
                                }
                            }
                            .onDelete { index in
                                viewModel.deleteDestination(at: index)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.selectImage()
        }
        .sheet(isPresented: $inputIsPresented) {
            DestinationInputView()
        }
    }
}

struct DestinationInputView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: PlannerViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Where do you want to go?")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color("text"))
                    TextField("", text: $viewModel.location)
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 0.5))
                        .background(Color("background"))
                        .cornerRadius(10)
                    Text("For how many days?")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color("text"))
                        .padding(.top, 10)
                    TextField("", text: $viewModel.numberOfDays)
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 0.5))
                        .background(Color("background"))
                        .cornerRadius(10)
                        .padding(0)
//                    Text("When would you like to go?")
//                        .font(.title3)
//                        .fontWeight(.bold)
//                        .foregroundColor(Color("text"))
//                        .padding(.top, 10)
//                    TextField("", text: $viewModel.timeOfYear)
//                        .padding(8)
//                        .background(RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 0.5))
//                        .background(Color("background"))
//                        .cornerRadius(10)
                    Text("Any specific sights or activities?")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color("text"))
                        .padding(.top, 10)
                    TextField("", text: $viewModel.sightsToSee)
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 0.5))
                        .background(Color("background"))
                        .cornerRadius(10)
                }
                VStack(alignment: .center) {
                    Button {
                        viewModel.addDestination()
                        if !viewModel.showAlert {
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        Text("Add Destination")
                            .font(.headline)
                            .foregroundColor(Color("background"))
                    }
                    .buttonStyle(CustomButtonStyle())
                }
                .padding(.vertical)
            }
        }
        .frame(height: 350)
        .padding()
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Ooops, there was an issue"), message: Text("it looks like you may not have entered anything in one or more fields."))
        }
    }
}

struct CustomButtonStyle: ButtonStyle {
    var color = Color.pink
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 45)
            .padding(.horizontal, 45)
            .foregroundColor(Color("background"))
            .background(configuration.isPressed ? color.opacity(0.5) : color.opacity(1.0))
            .cornerRadius(25)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationFormView()
            .environmentObject(PlannerViewModel(unsplashImage: nil, error: nil, response: nil))
            .environmentObject(OpenAIConnector())
    }
}

