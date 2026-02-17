//
//  TodayAdviceView.swift
//  kasacle-app
//
//  Created by 笠原涼太 on 2026/02/13.
//

import SwiftUI

/// 今日のアドバイスをランダムに返す（同じ日は同じアドバイス）
private func todayAdvice() -> Advice {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: .now)

    // 日付をシード値として使用（同じ日は同じアドバイス）
    let seed = components.year! * 10000 + components.month! * 100 + components.day!
    let index = abs(seed) % allAdvices.count

    return allAdvices[index]
}

// MARK: - TodayAdviceView

struct TodayAdviceView: View {
    private let advice = todayAdvice()

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ja_JP")
        f.dateFormat = "M月d日（E）"
        return f
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 日付
            Text(Self.dateFormatter.string(from: .now))
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(AppColor.onBrand.opacity(0.7))

            HStack(alignment: .top, spacing: 14) {
                // アイコン
                Image(systemName: advice.icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(AppColor.onBrand)
                    .frame(width: 32)

                VStack(alignment: .leading, spacing: 4) {
                    Text("今日のアドバイス")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(AppColor.onBrand.opacity(0.8))
                    Text(advice.message)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(AppColor.onBrand)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(AppColor.brand)
                .shadow(color: AppColor.brand.opacity(0.35), radius: 12, x: 0, y: 6)
        )
    }
}

#Preview {
    TodayAdviceView()
        .padding()
        .background(Color.white)
}
