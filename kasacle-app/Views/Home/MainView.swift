//
//  MainView.swift
//  kasacle-app
//
//  Created by 笠原涼太 on 2026/02/13.
//

import SwiftUI
import SwiftData

// MARK: - MainView

struct MainView: View {
    /// カレンダーでタップされた日付（nilなら遷移しない）
    @State private var selectedDate: Date? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                // 背景
                AppColor.appBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {

                        // ─── タイトルロゴ ─────────────────────────
                        VStack(spacing: 6) {
                            Text("KASACLE")
                                .font(.system(size: 36, weight: .black))
                                .tracking(8)
                                .foregroundStyle(AppColor.onBrand)

                            Text("筋トレ管理")
                                .font(.system(size: 13, weight: .medium))
                                .tracking(4)
                                .foregroundStyle(AppColor.onBrand.opacity(0.6))
                        }
                        .padding(.top, 16)

                        // ─── 今日のアドバイス ─────────────────────
                        TodayAdviceView()

                        // ─── ワークアウトカレンダー ───────────────
                        WorkoutCalendarView { tappedDate in
                            selectedDate = tappedDate
                        }

                        // ─── メニューボタン群 ─────────────────────
                        VStack(spacing: 14) {
                            NavigationLink {
                                WorkoutStartView()
                            } label: {
                                MenuButton(title: "ワークアウト開始", icon: "flame.fill", isPrimary: true)
                            }

                            NavigationLink {
                                // TODO: 記録一覧画面
                                Text("記録一覧")
                                    .navigationTitle("記録")
                            } label: {
                                MenuButton(title: "記録を見る", icon: "chart.bar.fill", isPrimary: false)
                            }

                            NavigationLink {
                                // TODO: 設定画面
                                Text("設定")
                                    .navigationTitle("設定")
                            } label: {
                                MenuButton(title: "設定", icon: "gearshape.fill", isPrimary: false)
                            }
                        }

                        Spacer(minLength: 32)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarHidden(true)
            // ─── カレンダータップ → 日別詳細画面へ ──────────
            .navigationDestination(item: $selectedDate) { date in
                DayWorkoutDetailView(date: date)
            }
        }
    }
}

// MARK: - MenuButton

private struct MenuButton: View {
    let title: String
    let icon: String
    let isPrimary: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
            Text(title)
                .font(.system(size: 18, weight: .semibold))
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .opacity(0.5)
        }
        .foregroundStyle(AppColor.onBrand)
        .padding(.horizontal, 24)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    isPrimary
                        ? Color.white.opacity(0.22)
                        : Color.white.opacity(0.10)
                )
                .shadow(color: AppColor.onBackground.opacity(0.15), radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    MainView()
        .modelContainer(for: WorkoutRecord.self, inMemory: true)
}
