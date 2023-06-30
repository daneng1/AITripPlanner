//
//  DayItineraryView.swift
//  AITripPlanner
//
//  Created by Dan and Beth Engel on 6/29/23.
//

import SwiftUI

struct DayItineraryView: View {
    @State private var detailsVisible: Bool = false
    var dailyDetails: Day
    
    var body: some View {
        VStack {
            Button {
                withAnimation {
                    detailsVisible.toggle()
                }
            } label: {
                HStack(spacing: 4) {
                    Text(dailyDetails.day)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color("secondary2"))
                    Text(" - ")
                        .font(.title2)
                        .foregroundColor(Color("secondary2"))
                    Text(dailyDetails.dayDescription)
                        .font(.title2)
                        .foregroundColor(Color("secondary2"))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color("secondary2"))
                .overlay(alignment: .leading) {
                    Image(systemName: "arrow.down")
                        .font(.headline)
                        .foregroundColor(Color("secondary2"))
                        .padding()
                        .rotationEffect(detailsVisible ? .degrees(-180) : .degrees(0))
                }
            }
            if detailsVisible {
                ScrollView {
                    ForEach(dailyDetails.itineraryItems, id: \.self) { detail in
                        DayDetailsView(details: detail)
                    }
                }
            }
        }
    }
}

struct DayItineraryView_Previews: PreviewProvider {
    static var previews: some View {
        let newItineraryItem = ItineraryItem(activity: "Rowing", activityDescription: "Lets go rowing", activityTips: "don't sink", link: "https://rowing.com")
        let newDay = Day(day: "Day 1", dayDescription: "See the sights", itineraryItems: [newItineraryItem])
        DayItineraryView(dailyDetails: newDay)
    }
}
