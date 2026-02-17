//
//  RootView.swift
//  kasacle-app
//
//  Created by 笠原涼太 on 2026/02/13.
//

import SwiftUI

struct RootView: View {
    @State private var isShowingSplash = true

    var body: some View {
        ZStack {
            MainView()
                .opacity(isShowingSplash ? 0 : 1)

            if isShowingSplash {
                SplashView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: isShowingSplash)
        .task {
            // スプラッシュを 1.8 秒表示してからメイン画面へ
            try? await Task.sleep(for: .seconds(1.8))
            isShowingSplash = false
        }
    }
}

#Preview {
    RootView()
}
