//
//  ContentView.swift
//  AITripPlanner
//
//  Created by Dan Engel on 6/20/23.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var viewModel: PlannerViewModel
    @EnvironmentObject var connector: OpenAIConnector
    @State var inputIsPresented = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("IMG_0901")
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    if !inputIsPresented {
                        Button {
                            withAnimation(.spring(response: 0.2)) {
                                inputIsPresented.toggle()
                            }
                        } label: {
                            Text("Plan my trip!")
                                .font(.headline)
                                .frame(width: 175, height: 35)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.bottom, 32)
                    } else {
                        inputView
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}

extension ContentView {
    var inputView: some View {
        VStack(alignment: .leading) {
            Text("Where do you want to go?")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color("secondary2"))
                .padding(.top, 10)
            TextField("", text: $viewModel.location)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 0.5))
            Text("For how many days?")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color("secondary2"))
                .padding(.top, 10)
            TextField("", text: $viewModel.numberOfDays)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 0.5))
            Text("When would you like to go?")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color("secondary2"))
                .padding(.top, 10)
            TextField("", text: $viewModel.timeOfYear)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 0.5).background(Color.white))
            Text("Sights and/or activities")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color("secondary2"))
                .padding(.top, 10)
            TextEditor(text: $viewModel.sightsToSee)
                .border(Color.black, width: 0.5)
                .frame(height: 100)
            Button {
                inputIsPresented.toggle()
                viewModel.buildQuery()
            } label: {
                NavigationLink(destination: TripResultsView(), label: {
                    Text("Plan Trip")
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .frame(width: 125, height: 35)
                }
                )
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Helper function to make type-erased views
extension View {
    func anyView() -> AnyView {
        AnyView(self)
    }
}
