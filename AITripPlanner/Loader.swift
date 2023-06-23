//
//  Loader.swift
//  AITripPlanner
//
//  Created by Dan and Beth Engel on 6/22/23.
//

import SwiftUI
import Combine

struct Loader: View {
    @State private var duration: Double = 0.75
    @State private var scale: CGFloat = 0.0
    @State private var rotateDegrees: Double = 0.0
    @State private var horizontalOffset: CGFloat = -55
    @State private var verticalOffset: CGFloat = 10
    @State private var opacity: Double = 1.0
    
//    let timer = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Circle()
                .fill(Color("secondary2"))
                .frame(width: 100, height: 100)
            Image(systemName: "globe.americas.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(Color("Green"))
            plane(angle: -30, horizontalOffset: -55, verticalOffset: 20, delayTimer: 2.0)
        }
    }
}

struct plane: View {
    @State private var angle: Double
    @State private var scale: CGFloat = 0.0
    @State private var rotateDegrees: Double = 0.0
    @State private var horizontalOffset: CGFloat
    @State private var verticalOffset: CGFloat
    @State private var opacity: Double = 1.0
    @State private var delayTimer: Double
    @State private var duration: Double = 0.75
    
    init(angle: Double, horizontalOffset: CGFloat, verticalOffset: CGFloat, delayTimer: Double) {
        self.angle = angle
        self.horizontalOffset = horizontalOffset
        self.verticalOffset = verticalOffset
        self.delayTimer = delayTimer

    }
    
    let timer = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()

    var body: some View {
        Image(systemName: "airplane")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(Color("primary"))
            .opacity(opacity)
            .frame(width: 50, height: 50)
            .scaleEffect(scale)
            .rotationEffect(.degrees(angle))
            .offset(x: horizontalOffset, y: verticalOffset)
            .animation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: false).delay(delayTimer), value: rotateDegrees)
            .onAppear() {
                withAnimation {
                    rotateDegrees = 360
                    let scaleAnimation = Animation.easeInOut(duration: duration).repeatForever(autoreverses: true)
                    let moveAnimation = Animation.easeInOut(duration: duration * 2).repeatForever(autoreverses: true)
                    withAnimation(scaleAnimation) {
                        scale = 0.5
                    }
                    withAnimation(moveAnimation) {
                        horizontalOffset = horizontalOffset * -1
                        verticalOffset = verticalOffset * -1
                    }
                }
            }
            .onReceive(timer) { _ in
                if opacity == 0.0 {
                    opacity = 1.0
                } else {
                    opacity = 0.0
                }
            }
        
    }
}

struct Loader_Previews: PreviewProvider {
    static var previews: some View {
        Loader()
    }
}
