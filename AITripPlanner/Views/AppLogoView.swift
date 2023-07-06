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
            Rectangle()
                .frame(width: 180, height: 180)
                .foregroundColor(Color.pink)
                .cornerRadius(20)
            Image("TRAVaiL_logo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 150)
        }
    }
}

struct AppLogoView_Previews: PreviewProvider {
    static var previews: some View {
        AppLogoView()
    }
}
