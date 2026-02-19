//
//  TodayAdviceView.swift
//  kasacle-app
//
//  Created by 笠原涼太 on 2026/02/13.
//

import SwiftUI

// MARK: - TodayAdviceView

struct TodayAdviceView: View {
    @Environment(\.modelContext) private var modelContext

    private let fallbackMessage = "アドバイスを取得できませんでした。少し時間をおいて再度お試しください。"
    @State private var generatedMessage: String?
    @State private var adviceErrorDetail: String?
    @State private var isGenerating = false

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
                .foregroundStyle(Color.secondary)

            HStack(alignment: .center, spacing: 14) {
                // アイコン
                Image(systemName: "sparkles")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(AppColor.brand)
                    .frame(width: 32)

                VStack(alignment: .leading, spacing: 4) {
                    Text("今日のアドバイス")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(AppColor.brand)
                    Text(generatedMessage ?? fallbackMessage)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(Color.primary)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)

                    if let adviceErrorDetail {
                        Text(adviceErrorDetail)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(Color.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    if isGenerating {
                        ProgressView()
                            .tint(AppColor.brand)
                            .scaleEffect(0.8, anchor: .leading)
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
        )
        .task {
            await generateAdviceIfNeeded()
        }
    }

    @MainActor
    private func generateAdviceIfNeeded() async {
        guard generatedMessage == nil else { return }
        adviceErrorDetail = nil
        isGenerating = true
        defer { isGenerating = false }

        let prompt = "筋トレ習慣化の前向きな助言を日本語で1つ。出力条件: 鉤括弧（「」『』）禁止、改行禁止、本文のみ。"

        do {
            var model = WorkoutAdviceModel()
            let message = try await model.generateAdvice(from: prompt, context: modelContext)
            if !message.isEmpty {
                generatedMessage = message
            }
        } catch WorkoutAdviceError.modelUnavailable {
            generatedMessage = WorkoutAdviceError.modelUnavailable.errorDescription
            adviceErrorDetail = nil
        } catch {
            generatedMessage = nil
            adviceErrorDetail = "原因: \(error.localizedDescription)"
            print("[FoundationModels] advice generation failed: \(error)")
        }
    }
}

#Preview {
    TodayAdviceView()
        .padding()
        .background(Color.white)
}
