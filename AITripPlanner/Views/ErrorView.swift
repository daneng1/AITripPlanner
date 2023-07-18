//
//  ErrorView.swift
//  AITripPlanner
//
//  Created by Dan and Beth Engel on 7/13/23.
//

import SwiftUI

struct ErrorView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 200, height: 200)
                .foregroundColor(Color("secondary1"))
                .cornerRadius(20)
            Rectangle()
                .frame(width: 295, height: 295)
                .foregroundColor(Color("primary"))
                .cornerRadius(20)
            Rectangle()
                .frame(width: 280, height: 280)
                .foregroundColor(Color("secondary1"))
                .cornerRadius(20)
            Image(systemName: "bolt.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(Color("primary"))
                .frame(width: 90)
            VStack(alignment: .center) {
                Text("OOPS, there was an error")
                    .foregroundColor(Color("background"))
                    .font(.title2)
                    .padding(.top, 32)
                Spacer()
                Text("It's not you, it's us. Please try your search again.")
                    .foregroundColor(Color("background"))
                    .frame(maxWidth: 250)
                    .padding(.bottom, 28)
                    .font(.title3)
            }
        }
        .frame(width: 200, height: 200)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
