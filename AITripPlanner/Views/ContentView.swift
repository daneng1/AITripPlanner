//
//  ContentView.swift
//  AITripPlanner
//
//  Created by Dan Engel on 6/20/23.
//

import SwiftUI
import Combine

struct ContentView: View {
    @EnvironmentObject var viewModel: PlannerViewModel
    @EnvironmentObject var connector: OpenAIConnector
    @State private var inputIsPresented = false
    @State private var showDetailView: Bool = false
    @State private var keyboardHeight: CGFloat = 0
    @State private var cancellableSet: Set<AnyCancellable> = []
    
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
                        AppLogoView()
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
                            .transition(.move(edge: .bottom))
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                            .navigationDestination(isPresented: $showDetailView) {
                                TripResultsView()
                            }
                    }
                }
                .animation(.easeInOut, value: keyboardHeight)
                .padding(.bottom, keyboardHeight)
                .edgesIgnoringSafeArea(.bottom)
            }
        }
        .onAppear {
            viewModel.selectImage()
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
                .map { $0.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect }
                .map { $0.height }
                .sink { height in
                    DispatchQueue.main.async {
                        self.keyboardHeight = height
                        }
                    }
                .store(in: &cancellableSet)

            NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
                .sink { height in
                    DispatchQueue.main.async {
                        self.keyboardHeight = height
                        }
                    }
                .store(in: &cancellableSet)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Ooops, there was an issue"), message: Text("it looks like you may not have entered anything in one or more fields."))
        }
    }
}

extension ContentView {
    var inputView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Where do you want to go?")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
            TextField("", text: $viewModel.location)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 0.5))
                .background(.white)
                .cornerRadius(10)
            Text("For how many days?")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
                .padding(.top, 10)
            TextField("", text: $viewModel.numberOfDays)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 0.5))
                .background(.white)
                .cornerRadius(10)
                .padding(0)
            Text("When would you like to go?")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
                .padding(.top, 10)
            TextField("", text: $viewModel.timeOfYear)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 0.5))
                .background(.white)
                .cornerRadius(10)
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
            .padding(.top, 8)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.bottom, 16)
    }
}

struct CustomButtonStyle: ButtonStyle {
    var color = Color.pink
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 45)
            .padding(.horizontal, 45)
            .foregroundColor(.white)
            .background(configuration.isPressed ? color.opacity(0.5) : color.opacity(1.0))
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
