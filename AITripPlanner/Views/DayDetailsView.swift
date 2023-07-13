//
//  DayDetailsView.swift
//  AITripPlanner
//
//  Created by Dan Engel on 6/29/23.
//

import SwiftUI

struct DayDetailsView: View {
    var details: ItineraryItem
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(details.activity)
                .font(.subheadline)
                .fontWeight(.bold)
            Text(details.activityDescription)
                .font(.subheadline)
            VStack(alignment: .leading) {
                ZStack {
                    Rectangle()
                        .frame(width: 80, height: 25)
                        .foregroundColor(Color("secondary2"))
                        .cornerRadius(15)
                        .offset(x: 2, y:2)
                    Text("Hot Tip")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(Color("secondary1"))
                        .frame(width: 80, height: 25)
                        .background(Color("primary"))
                        .cornerRadius(15)
                }
                .padding(.top, 8)
                .padding(.bottom, 4)
                Text(details.activityTips)
                    .font(.subheadline)
                    .frame(maxHeight: .infinity)
            }
            .padding(.top, 4)
            if let link = details.link,
               let url = URL(string: link) {
                Link(destination: url) {
                    Text("Learn more")
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.white)
        .cornerRadius(10)
        .padding(.vertical, 8)
    }
}

struct DayDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let newItineraryItem = ItineraryItem(activity: "Rowing", activityDescription: "Lets go rowing around the whole puget sound", activityTips: "don't sink the boat because that would be really, really, really, really bad", link: "https://rowing.com")
        DayDetailsView(details: newItineraryItem)
    }
}
