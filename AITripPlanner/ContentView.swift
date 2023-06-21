//
//  ContentView.swift
//  AITripPlanner
//
//  Created by Dan Engel on 6/20/23.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var connector: OpenAIConnector
    @State var sheetIsPresented = false
    
    var body: some View {
        ZStack {
            Image("IMG_0901")
                .resizable()
                .scaledToFill()
                .clipped()
                .edgesIgnoringSafeArea(.vertical)
            VStack {
                Spacer()
                Button {
                    sheetIsPresented.toggle()
                } label: {
                    Text("Plan my trip!")
                        .font(.headline)
                        .frame(width: 175, height: 35)
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 32)
            }
        }
        .sheet(isPresented: $sheetIsPresented) {
            inputView
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
            TextField("", text: $connector.location)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 0.5))
            Text("For how many days?")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color("secondary2"))
                .padding(.top, 10)
            TextField("", text: $connector.numberOfDays)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 0.5))
            Text("When would you like to go?")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color("secondary2"))
                .padding(.top, 10)
            TextField("", text: $connector.timeOfYear)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 0.5).background(Color.white))
            Text("Sights and/or activities")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color("secondary2"))
                .padding(.top, 10)
            TextEditor(text: $connector.sightsToSee)
                .border(Color.black, width: 0.5)
                .frame(height: 100)
            Button{
                connector.buildQuery()
            } label: {
                Text("Plan Trip")
                    .font(.headline)
                    .frame(width: 125, height: 35)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .presentationBackground(.thinMaterial)
    }
    
    var resultsView: some View {
        VStack {
            toSwiftUI(connector.response)
        }
    }
    
    private func toSwiftUI(_ output: String) -> some View {
        let lines = output.components(separatedBy: "\n")
        var swiftUIViews: [AnyView] = []

        // First line to be headline
        swiftUIViews.append(Text(lines[0]).font(.headline).anyView())

        // Format remaining lines
        for i in 1..<(lines.count - 1) {  // Skip first line and last line
            let line = lines[i]
            let previousLine = lines[i - 1]

            // If a line follows an empty line, make it subhead
            if previousLine.isEmpty && !line.isEmpty {
                swiftUIViews.append(
                    Text(line)
                        .font(.subheadline)
                        .anyView()
                )
            }
            // If line contains hyperlink, make it a Button
            else if let url = URL(string: line), UIApplication.shared.canOpenURL(url) {
                swiftUIViews.append(
                    Button(action: {
                        UIApplication.shared.open(url)
                    }) {
                        Text(line)
                    }
                        .anyView()
                )
            }
            // Otherwise, it's body text
            else {
                swiftUIViews.append(Text(line).font(.body).anyView())
            }
        }

        return VStack {
            ForEach(0..<swiftUIViews.count) { idx in
                swiftUIViews[idx]
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MessageView: View {
    var message: [String: String]
    
    var messageColor: Color {
        if message["role"] == "user" {
            return .gray
        } else if message["role"] == "assistant" {
            return .green
        } else {
            return .red
        }
    }
    
    var body: some View {
        if message["role"] != "system" {
            HStack {
                if message["role"] == "user" {
                    Spacer()
                }
                
                
                Text(message["content"] ?? "error")
                    .foregroundColor(.white)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 25).foregroundColor(messageColor))
                    .shadow(radius: 25).cornerRadius(25)
                
                if message["role"] == "assistant" {
                    Spacer()
                }
            }
        }
    }
}
