//
//  TodayAdviceView.swift
//  kasacle-app
//
//  Created by 笠原涼太 on 2026/02/13.
//

import SwiftUI

// MARK: - アドバイスデータ

private struct Advice {
    let icon: String
    let message: String
}

/// 曜日に応じたアドバイスを返す
private func todayAdvice() -> Advice {
    let weekday = Calendar.current.component(.weekday, from: .now)
    switch weekday {
    case 1: // 日
        return Advice(icon: "moon.zzz.fill",   message: "今日はしっかり休養しましょう。睡眠と栄養補給が筋肉の回復を助けます。")
    case 2: // 月
        return Advice(icon: "flame.fill",       message: "週の始まり！胸・肩・三頭筋のプッシュ系トレーニングでスタートダッシュを切りましょう。")
    case 3: // 火
        return Advice(icon: "figure.walk",      message: "昨日の疲れを感じたら軽いウォーキングやストレッチで回復を促しましょう。")
    case 4: // 水
        return Advice(icon: "dumbbell.fill",    message: "背中・二頭筋のプル系トレーニングに最適な曜日。しっかり追い込みましょう！")
    case 5: // 木
        return Advice(icon: "drop.fill",        message: "水分補給を意識しながら軽めの有酸素運動を取り入れてみましょう。")
    case 6: // 金
        return Advice(icon: "bolt.fill",        message: "週末前の追い込みデー！脚・臀部のトレーニングで代謝をアップさせましょう。")
    case 7: // 土
        return Advice(icon: "heart.fill",       message: "週末はアクティブレスト。ヨガやストレッチで全身をケアするのがおすすめです。")
    default:
        return Advice(icon: "star.fill",        message: "今日も一歩一歩、着実に積み上げていきましょう！")
    }
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
                .foregroundStyle(AppColor.onBrand.opacity(0.6))

            HStack(alignment: .top, spacing: 14) {
                // アイコン
                Image(systemName: advice.icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(AppColor.onBrand)
                    .frame(width: 32)

                VStack(alignment: .leading, spacing: 4) {
                    Text("今日のアドバイス")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(AppColor.onBrand.opacity(0.7))
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
                .fill(Color.white.opacity(0.12))
        )
    }
}

#Preview {
    TodayAdviceView()
        .padding()
        .background(AppColor.brand)
}
