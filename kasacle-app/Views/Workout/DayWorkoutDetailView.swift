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
                        .foregroundStyle(AppColor.onSurface.opacity(0.25))

                    Text("この日の記録はありません")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(AppColor.onSurface.opacity(0.45))
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

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // セッションが空の場合
            if record.sessions.isEmpty {
                Text("記録なし")
                    .font(.system(size: 15))
                    .foregroundStyle(AppColor.onSurface.opacity(0.35))
                    .italic()
            } else {
                ForEach(record.sessions) { session in
                    WorkoutSessionRow(session: session)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppColor.onSurface.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(AppColor.onSurface.opacity(0.08), lineWidth: 1)
                )
        )
    }
}

// MARK: - WorkoutSessionRow

private struct WorkoutSessionRow: View {
    let session: WorkoutSession

    private var timeText: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ja_JP")
        f.dateFormat = "HH:mm"
        return f.string(from: session.startedAt)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // ヘッダー：種目名 + 時刻
            HStack(spacing: 6) {
                Text(session.exerciseName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppColor.onSurface)
                Spacer()
                Image(systemName: "clock.fill")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(AppColor.onSurface.opacity(0.45))
                Text(timeText)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(AppColor.onSurface.opacity(0.45))
            }

            // 部位バッジ
            Text(session.muscleGroup)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(AppColor.brand)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(
                    Capsule()
                        .fill(AppColor.brand.opacity(0.10))
                )

            Divider()
                .overlay(AppColor.onSurface.opacity(0.1))

            // セット一覧
            if session.sets.isEmpty {
                Text("セットなし")
                    .font(.system(size: 13))
                    .foregroundStyle(AppColor.onSurface.opacity(0.35))
                    .italic()
            } else {
                ForEach(session.sets.sorted { $0.setNumber < $1.setNumber }) { set in
                    HStack {
                        Text("セット \(set.setNumber)")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(AppColor.onSurface.opacity(0.5))
                        Spacer()
                        if let kg = set.weightKg {
                            Text("\(kg, specifier: "%.1f") kg × \(set.reps) 回")
                        } else {
                            Text("自重 × \(set.reps) 回")
                        }
                        Text("(\(set.durationSeconds)秒)")
                            .font(.system(size: 12))
                            .foregroundStyle(AppColor.onSurface.opacity(0.4))
                    }
                    .font(.system(size: 13))
                    .foregroundStyle(AppColor.onSurface)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DayWorkoutDetailView(date: .now)
            .modelContainer(for: WorkoutRecord.self, inMemory: true)
    }
}
