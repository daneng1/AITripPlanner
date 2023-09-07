//
//  Loader.swift
//  AITripPlanner
//
//  Created by Dan Engel on 6/22/23.
//

import SwiftUI
import Combine

struct LoaderView: View {
    @State private var secondPlaneIsActive = false
    @State private var thirdPlaneIsActive = false
    
    var body: some View {
        VStack {
            ZStack {
                earth()
                plane(angle: -30, horizontalOffset: -55, verticalOffset: 20, delayTimer: 2.5)
                if secondPlaneIsActive {
                    plane(angle: 40, horizontalOffset: -45, verticalOffset: -40, delayTimer: 2.5)
                }
                if thirdPlaneIsActive {
                    plane(angle: 0, horizontalOffset: -60, verticalOffset: 0, delayTimer: 2.5)
                }
            }
            .padding(.bottom, 32)
            Text("Okay, we're on it!")
                .font(.headline)
                .foregroundColor(Color("secondary2"))
                .padding(.bottom, 0)
            Text("This could take a minute, we're gathering all the latest travel info to build your trip.")
                .font(.subheadline)
                .foregroundColor(Color("secondary2"))
                .padding(.top, 4)
                .padding(.horizontal, 24)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.secondPlaneIsActive = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.thirdPlaneIsActive = true
            }
        }
    }
}

struct earth: View {
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color("primary"))
                .frame(width: 100, height: 100)
            Image(systemName: "globe.americas.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(Color("secondary1"))
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
    @State private var delayTimer: CGFloat
    @State private var duration: Double = 0.75000
    @State private var timer: Timer? = nil
    
    init(angle: Double, horizontalOffset: CGFloat, verticalOffset: CGFloat, delayTimer: Double) {
        _angle = State(initialValue: angle)
        _horizontalOffset = State(initialValue: horizontalOffset)
        _verticalOffset = State(initialValue: verticalOffset)
        _delayTimer = State(initialValue: delayTimer)
    }

    var body: some View {
        Image(systemName: "airplane")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(Color("secondary2"))
            .opacity(opacity)
            .frame(width: 50, height: 50)
            .scaleEffect(scale)
            .rotationEffect(.degrees(angle))
            .offset(x: horizontalOffset, y: verticalOffset)
            .animation(Animation
                .easeInOut(duration: 3.0000)
                .delay(delayTimer)
                .repeatForever(autoreverses: false),
                       value: rotateDegrees)
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
                    
                    timer = Timer.scheduledTimer(withTimeInterval: 1.5000, repeats: true) { _ in
                        if opacity == 0.0 {
                            opacity = 1.0
                        } else {
                            opacity = 0.0
                        }
                    }
                }
            }
    }
}

struct Loader_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView()
    }
}
