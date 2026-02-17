//
//  MainView.swift
//  kasacle-app
//
//  Created by 笠原涼太 on 2026/02/13.
//

import SwiftUI

struct MainView: View {
    @State private var selectedDate: Date = .now
    @State private var isWorkoutPresented = false

    // 今日のアドバイス（後で動的に差し替え可能）
    private let todayAdvice = "今日は胸・肩を重点的に鍛えましょう。前回のトレーニングから48時間以上経過しています。しっかり追い込んでいきましょう！"

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(spacing: 20) {

                        // ── 今日のアドバイス ──────────────────────
                        AdviceCardView(advice: todayAdvice)

                        // ── カレンダー ────────────────────────────
                        CalendarCardView(selectedDate: $selectedDate)

                        // FABの下に隠れないための余白
                        Color.clear.frame(height: 88)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }

                // ── FAB（＋ボタン）────────────────────────────
                Button {
                    isWorkoutPresented = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 60, height: 60)
                        .background(.tint, in: Circle())
                        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
                }
                .padding(.trailing, 24)
                .padding(.bottom, 32)
            }
            .navigationTitle("KASACLE")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $isWorkoutPresented) {
            WorkoutStartView()
        }
    }
}

// MARK: - 今日のアドバイスカード

private struct AdviceCardView: View {
    let advice: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("今日のアドバイス", systemImage: "lightbulb.fill")
                .font(.headline)
                .foregroundStyle(.orange)

            Text(advice)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .lineSpacing(4)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.orange.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.orange.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - カレンダーカード

private struct CalendarCardView: View {
    @Binding var selectedDate: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("カレンダー", systemImage: "calendar")
                .font(.headline)
                .foregroundStyle(.tint)

            DatePicker(
                "",
                selection: $selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .labelsHidden()
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.separator, lineWidth: 0.5)
        )
    }
}

#Preview {
    MainView()
}
