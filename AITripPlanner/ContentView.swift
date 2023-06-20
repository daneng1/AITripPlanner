//
//  ContentView.swift
//  AITripPlanner
//
//  Created by Dan and Beth Engel on 6/20/23.
//

import SwiftUI


struct ContentView: View {

    @EnvironmentObject var connector: OpenAIConnector
    var body: some View {
        VStack {
            ScrollView {
                Text(connector.response)
                    .font(.body)
            }
            Divider()
            TextField("Where do you want to go?", text: $connector.location)
                .border(Color.gray, width: 1)
                .font(.title2)
            TextField("How many days?", text: $connector.numberOfDays)
                .border(Color.gray, width: 1)
                .font(.title2)
            TextField("When would you like to go?", text: $connector.timeOfYear)
                .border(Color.gray, width: 1)
                .font(.title2)
            Text("Sights or activities you'd like to see?")
                .font(.title2)
            TextEditor(text: $connector.sightsToSee)
                 .frame(height: 100)
                 .border(Color.gray, width: 1)
            Button{
                connector.buildQuery()
            } label: {
                Text("Send")
            }
        }
        .padding()
//        VStack {
//            ScrollView {
//                ForEach(connector.messageLog) { message in
//                    MessageView(message: message)
//                }
//            }
//
//            Divider()
//
//            HStack {
//                TextField("Type here", text: $textField)
//                Button("Send") {
//                    connector.logMessage(textField, messageUserType: .user)
//                    connector.sendToAssistant()
//                    print("messageLog")
//                }
//            }
//
//        }.padding()
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
