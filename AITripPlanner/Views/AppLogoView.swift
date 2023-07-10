//
//  AppLogoView.swift
//  AITripPlanner
//
//  Created by Dan and Beth Engel on 7/6/23.
//

import SwiftUI

struct AppLogoView: View {
    
    var body: some View {
        ZStack {
            Image("T")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 110)
                .cornerRadius(20)
                .transition(.opacity)
        }
    }
}

struct AppLogoView_Previews: PreviewProvider {
    static var previews: some View {
        AppLogoView()
    }
}
