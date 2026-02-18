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
            AppColor.brand
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Image("kasacle-logo-horiz-white")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 70)
                    .opacity(titleOpacity)
                    .scaleEffect(titleScale)

                Text("筋トレ管理")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .opacity(titleOpacity)
            }
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
