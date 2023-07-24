//
//  SplashView.swift
//  AITripPlanner
//
//  Created by Dan and Beth Engel on 7/24/23.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var viewModel: PlannerViewModel
    @EnvironmentObject var connector: OpenAIConnector
    @State private var isNavActive = false
    
    var body: some View {
        NavigationView {
            VStack {
                if isNavActive {
                    DestinationFormView()
                } else {
                    AppLogoView()
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    self.isNavActive = true
                }
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
