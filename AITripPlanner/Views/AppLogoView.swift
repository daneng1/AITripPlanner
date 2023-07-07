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
                .frame(width: 120, height: 120)
                .foregroundColor(Color.pink)
                .cornerRadius(20)
            Image("TRAVaiL_logo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 110)
        }
    }
}

struct AppLogoView_Previews: PreviewProvider {
    static var previews: some View {
        AppLogoView()
    }
}
