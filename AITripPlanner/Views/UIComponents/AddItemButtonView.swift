//
//  AddItemButtonView.swift
//  AITripPlanner
//
//  Created by Dan Engel on 7/25/23.
//

import SwiftUI

struct AddItemButtonView: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color("secondary1"))
                .frame(width: 40)
            Image(systemName: "plus")
                .resizable()
                .scaledToFit()
                .foregroundColor(Color("primary"))
                .frame(width: 20)
        }
    }
}

struct AddItemButtonView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemButtonView()
    }
}
