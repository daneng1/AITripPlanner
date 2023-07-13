//
//  ImageCarouselView.swift
//  AITripPlanner
//
//  Created by Dan Engel on 7/11/23.
//

import SwiftUI
import URLImageModule

struct ImageCarouselView: View {
    @EnvironmentObject var viewModel: PlannerViewModel
    @State private var selectedPageIndex = 0

    var body: some View {
        Text("Hello world")
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 0) {
//                if let images = viewModel.unsplashImage {
//                    ForEach(0..<images.count, id: \.self) { index in
//                            URLImage(url: URL(string: images[index].urls.regular)!) { image in
//                                image
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .accessibility(label: Text(images[index].altDescription))
//                            }
//                    }
//                } else {
//
//                }
//            }
//        }
//        .frame(height: 200)
//        .onReceive( Timer.publish(every: 3, on: .main, in: .common).autoconnect() ) { _ in
//            withAnimation {
//                if let images = viewModel.unsplashImages {
//                    selectedPageIndex = (selectedPageIndex + 1) % images.count
//                    let scrollPoint = CGPoint(x: CGFloat(selectedPageIndex) * UIScreen.main.bounds.width, y: 0)
//                    UIScrollView.appearance().setContentOffset(scrollPoint, animated: true)
//                }
//            }
//        }
    }
}

struct ImageCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        ImageCarouselView()
    }
}
