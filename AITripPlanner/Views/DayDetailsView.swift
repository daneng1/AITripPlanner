//
//  DayDetailsView.swift
//  AITripPlanner
//
//  Created by Dan and Beth Engel on 6/29/23.
//

import SwiftUI

struct DayDetailsView: View {
    var details: ItineraryItem
    var body: some View {
        VStack(alignment: .leading) {
            Text(details.activity)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.black)
            Text(details.activityDescription)
                .font(.subheadline)
                .foregroundColor(.black)
            VStack(alignment: .leading) {
                Text("Hot Tip")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(Color("primary"))
                Text(details.activityTips)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .frame(maxHeight: .infinity)
            }
            .padding(.top, 4)
            if let link = details.link,
               let url = URL(string: link) {
                Link(destination: url) {
                    Text("Learn more")
                }
            }
            Divider()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}

struct DayDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let newItineraryItem = ItineraryItem(activity: "Rowing", activityDescription: "Lets go rowing around the whole puget sound", activityTips: "don't sink the boat because that would be really, really, really, really bad", link: "https://rowing.com")
        DayDetailsView(details: newItineraryItem)
    }
}