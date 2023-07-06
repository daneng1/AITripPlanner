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
    @State var showDetailView: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image(viewModel.selectedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: UIScreen.main.bounds.width)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    if !inputIsPresented {
                        ZStack {
                            Rectangle()
                                .frame(width: 180, height: 220)
                                .foregroundColor(Color.pink)
                                .cornerRadius(20)
                            VStack {
                                Image("TRAVaiL_logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 150)
                                    .padding(.top, 10)
                                Image("TRAVaiL_font")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 150)
                            }
                        }

                        Spacer()
                        Button {
                            withAnimation(.spring(response: 0.2)) {
                                inputIsPresented.toggle()
                            }
                        } label: {
                            Text("Plan my trip!")
                                .font(.headline)
                        }
                        .buttonStyle(CustomButtonStyle(color: Color.pink))
                        .padding(.bottom, 32)
                    } else {
                        inputView
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                            .navigationDestination(isPresented: $showDetailView) {
                                TripResultsView()
                            }
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
        .onAppear {
            viewModel.selectImage()
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Ooops, there was an issue"), message: Text("it looks like you may not have entered anything in one or more fields."))
        }
    }
}

extension ContentView {
    var inputView: some View {
        VStack(alignment: .leading) {
            Text("Where do you want to go?")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
                .padding(.top, 10)
            TextField("", text: $viewModel.location)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 0.5))
            Text("For how many days?")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
                .padding(.top, 10)
            TextField("", text: $viewModel.numberOfDays)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 0.5))
            Text("When would you like to go?")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
                .padding(.top, 10)
            TextField("", text: $viewModel.timeOfYear)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 0.5))
            Text("Sights and/or activities")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
                .padding(.top, 10)
            TextEditor(text: $viewModel.sightsToSee)
                .border(Color.black, width: 0.5)
                .frame(height: 100)
            NavigationLink(destination: TripResultsView()) {
                Button {
                    if viewModel.checkValid() {
                        showDetailView.toggle()
                        viewModel.loading = true
                    }
                } label: {
                    Text("Plan Trip")
                        .font(.headline)
                        .foregroundColor(Color.white)
                }
                .buttonStyle(CustomButtonStyle())
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.bottom, 32)
    }
}

struct CustomButtonStyle: ButtonStyle {
    var color = Color.pink
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 45)
            .padding(.horizontal, 45)
            .foregroundColor(.white)
            .background(configuration.isPressed ? color.opacity(0.5) : color.opacity(0.8))
            .cornerRadius(25)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PlannerViewModel(unsplashImage: nil, error: nil, response: nil))
            .environmentObject(OpenAIConnector())
    }
}

// Helper function to make type-erased views
extension View {
    func anyView() -> AnyView {
        AnyView(self)
    }
}
