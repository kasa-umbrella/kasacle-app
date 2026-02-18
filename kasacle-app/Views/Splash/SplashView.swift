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
            // 背景：メインカラー #0067c0
            Color(red: 0 / 255, green: 103 / 255, blue: 192 / 255)
                .ignoresSafeArea()

                                        Image("kasacle-logo-horiz-blue")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 40)
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
