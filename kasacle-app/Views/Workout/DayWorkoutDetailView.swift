//
//  DayWorkoutDetailView.swift
//  kasacle-app
//
//  Created by 笠原涼太 on 2026/02/13.
//

import SwiftUI
import SwiftData

// MARK: - DayWorkoutDetailView

/// 選択された日付のワークアウト記録を表示する画面
struct DayWorkoutDetailView: View {
    let date: Date

    @Query private var allRecords: [WorkoutRecord]
    @Environment(\.modelContext) private var context

    private let calendar = Calendar.current

    /// 選択日のレコードだけにフィルタリング
    private var recordsForDay: [WorkoutRecord] {
        let target = calendar.startOfDay(for: date)
        return allRecords.filter { calendar.startOfDay(for: $0.date) == target }
    }

    private var titleText: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ja_JP")
        f.dateFormat = "yyyy年M月d日（E）"
        return f.string(from: date)
    }

    var body: some View {
        ZStack {
            AppColor.appBackground
                .ignoresSafeArea()

            if recordsForDay.isEmpty {
                // ─── 記録なし ───────────────────────────────
                VStack(spacing: 16) {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.system(size: 56))
                        .foregroundStyle(AppColor.onBrand.opacity(0.4))

                    Text("この日の記録はありません")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(AppColor.onBrand.opacity(0.6))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // ─── 記録リスト ──────────────────────────────
                ScrollView {
                    VStack(spacing: 14) {
                        ForEach(recordsForDay) { record in
                            WorkoutRecordCard(record: record)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                }
            }
        }
        .navigationTitle(titleText)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - WorkoutRecordCard

private struct WorkoutRecordCard: View {
    let record: WorkoutRecord

    private var timeText: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ja_JP")
        f.dateFormat = "HH:mm"
        return f.string(from: record.date)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // 時刻バッジ
            HStack(spacing: 6) {
                Image(systemName: "clock.fill")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(AppColor.onBrand.opacity(0.7))
                Text(timeText)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(AppColor.onBrand.opacity(0.7))
                Spacer()
            }

            Divider()
                .overlay(AppColor.onBrand.opacity(0.2))

            // メモ内容
            if record.note.isEmpty {
                Text("メモなし")
                    .font(.system(size: 15))
                    .foregroundStyle(AppColor.onBrand.opacity(0.4))
                    .italic()
            } else {
                Text(record.note)
                    .font(.system(size: 15))
                    .foregroundStyle(AppColor.onBrand)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.12))
        )
    }
}

#Preview {
    NavigationStack {
        DayWorkoutDetailView(date: .now)
            .modelContainer(for: WorkoutRecord.self, inMemory: true)
    }
}
