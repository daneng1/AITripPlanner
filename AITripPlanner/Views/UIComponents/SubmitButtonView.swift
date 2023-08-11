//
//  SubmitButtonView.swift
//  AITripPlanner
//
//  Created by Dan Engel on 7/25/23.
//

import SwiftUI

struct SubmitButtonView: View {
    var text: String
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 45)
                .cornerRadius(.infinity)
                .padding(.horizontal, 16)
                .foregroundColor(Color("secondary2"))
            Text(text)
                .font(.headline)
                .bold()
                .foregroundColor(Color("background"))
        }
        .padding(.vertical)
    }
}

struct SubmitButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SubmitButtonView(text: "Lets go!!")
    }
}
