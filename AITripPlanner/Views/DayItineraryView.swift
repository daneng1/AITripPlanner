//
//  DayItineraryView.swift
//  AITripPlanner
//
//  Created by Dan Engel on 6/29/23.
//

import SwiftUI

struct DayItineraryView: View {
    @State private var detailsVisible: Bool = false
    var dailyDetails: DestinationItinerary
    
    var body: some View {
        VStack {
            Button {
                withAnimation {
                    detailsVisible.toggle()
                }
            } label: {
                HStack(spacing: 4) {
                    Text(dailyDetails.dayTitle)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color("background"))
                        .padding(.leading, 40)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color("secondary2"))
                .overlay(alignment: .leading) {
                    Image(systemName: "arrow.down")
                        .font(.headline)
                        .foregroundColor(Color("background"))
                        .padding()
                        .rotationEffect(detailsVisible ? .degrees(-180) : .degrees(0))
                }
            }
            .cornerRadius(10)
            if detailsVisible {
                ScrollView {
                    Text(dailyDetails.dayDescription)
                        .font(.headline)
                        .foregroundColor(Color("text"))
                    ForEach(dailyDetails.dayItineraryItems, id: \.self) { detail in
                        DayDetailsView(details: detail)
                    }
                }
            }
        }
    }
}

struct DayItineraryView_Previews: PreviewProvider {
    static var previews: some View {
        let newItineraryItem = ItineraryItem(activityTitle: "Rowing", activityDescription: "Lets go rowing", activityTips: "don't sink", link: "https://rowing.com")
        let newDay = DestinationItinerary(dayTitle: "Day 1", dayDescription: "See the sights, here is a long description that includes lots and lots of text", dayItineraryItems: [newItineraryItem])
        DayItineraryView(dailyDetails: newDay)
    }
}
