//
//  DeleteItemView.swift
//  AITripPlanner
//
//  Created by Dan Engel on 8/10/23.
//

import SwiftUI

struct DeleteItemView: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color("secondary1"))
                .frame(width: 40)
            Image(systemName: "trash")
                .resizable()
                .scaledToFit()
                .foregroundColor(Color("primary"))
                .frame(width: 17)
        }
    }
}

struct DeleteItemView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteItemView()
    }
}
