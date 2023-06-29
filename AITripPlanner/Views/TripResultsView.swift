//
//  TripResultsView.swift
//  AITripPlanner
//
//  Created by Dan Engel on 6/23/23.
//

import SwiftUI

struct TripResultsView: View {
    @EnvironmentObject var viewModel: PlannerViewModel
    
    var body: some View {
        ZStack {
            Image(viewModel.selectedImage)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: UIScreen.main.bounds.width)
                .edgesIgnoringSafeArea(.all)
                .opacity(0.2)
            ScrollView {
                VStack {
                    if viewModel.error != nil {
                        Text(viewModel.error?.localizedDescription ?? "Sorry there was an error")
                    } else if viewModel.response != nil {
                        Text(viewModel.response?.location ?? "Psych!!!")
                    } else {
                        Spacer()
                        LoaderView()
                    }
                }
            }
            //            .background(.ultraThinMaterial)
            
            .padding()
        }
        .onAppear {
            viewModel.buildQuery()
        }
//        .background(Color.white.opacity(0.3))
    }
    
//    private func toSwiftUI(_ output: String) -> some View {
//        let lines = output.components(separatedBy: "\n")
//        var swiftUIViews: [AnyView] = []
//
//        // First line to be headline
//        swiftUIViews.append(Text(lines[0]).font(.headline).anyView())
//
//        // Format remaining lines
//        for i in 1..<(lines.count - 1) {  // Skip first line and last line
//            let line = lines[i]
//            let previousLine = lines[i - 1]
//
//            // If a line follows an empty line, make it subhead
//            if previousLine.isEmpty && !line.isEmpty {
//                swiftUIViews.append(
//                    Text(line)
//                        .font(.subheadline)
//                        .anyView()
//                )
//            }
//            // If line contains hyperlink, make it a Button
//            else if let url = URL(string: line), UIApplication.shared.canOpenURL(url) {
//                swiftUIViews.append(
//                    Button(action: {
//                        UIApplication.shared.open(url)
//                    }) {
//                        Text(line)
//                    }
//                        .anyView()
//                )
//            }
//            // Otherwise, it's body text
//            else {
//                swiftUIViews.append(Text(line).font(.body).anyView())
//            }
//        }
//
//        return VStack {
//            ForEach(0..<swiftUIViews.count) { idx in
//                swiftUIViews[idx]
//            }
//        }
//    }
}

struct TripResultsView_Previews: PreviewProvider {
    static var previews: some View {
        TripResultsView()
    }
}
