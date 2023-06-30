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
            HStack(spacing: 0) {
                Text("Hot Tip: ")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color("primary"))
                Text(details.activityTips)
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            .padding(.top, 4)
            Link(destination: URL(string: details.link)!) {
                Text("Learn more")
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}

struct DayDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let newItineraryItem = ItineraryItem(activity: "Rowing", activityDescription: "Lets go rowing", activityTips: "don't sink", link: "https://rowing.com")
        DayDetailsView(details: newItineraryItem)
    }
}
