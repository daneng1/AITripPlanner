//
//  SplashView.swift
//  AITripPlanner
//
//  Created by Dan Engel on 7/24/23.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var viewModel: PlannerViewModel
    @EnvironmentObject var connector: OpenAIConnector
    @State private var isNavActive = false
    @State private var opacity: Double = 1.0
    @State private var scale: CGFloat = 1
    
    var body: some View {
            ZStack {
                Image(viewModel.selectedImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: UIScreen.main.bounds.width)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.6)
                VStack {
                    if isNavActive {
                        DestinationFormView()
                    } else {
                        AppLogoView()
                            .opacity(opacity)
                            .scaleEffect(scale)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                                    withAnimation(.spring(response: 1.0, dampingFraction: 0.5 )) {
                                        scale = 0.8
                                    }
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.9 )) {
                                        scale = UIScreen.main.bounds.width / 25
                                    }
                                    withAnimation(Animation.easeIn(duration: 1)) {
                                        opacity = 0
                                    }
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                    withAnimation {
                                        self.isNavActive = true
                                    }
                                }
                            }
                    }
                }
            }
        .onAppear {
            viewModel.selectImage()
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
