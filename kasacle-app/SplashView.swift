//
//  SplashView.swift
//  kasacle-app
//
//  Created by 笠原涼太 on 2026/02/13.
//

import SwiftUI

struct SplashView: View {
    @State private var titleOpacity: Double = 0
    @State private var titleScale: Double = 0.85

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            Text("KASACLE")
                .font(.system(size: 48, weight: .black, design: .default))
                .tracking(8)
                .foregroundStyle(.white)
                .opacity(titleOpacity)
                .scaleEffect(titleScale)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                titleOpacity = 1
                titleScale = 1.0
            }
        }
    }
}

#Preview {
    SplashView()
}
