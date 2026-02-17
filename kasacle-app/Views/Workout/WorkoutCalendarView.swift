//
//  WorkoutCalendarView.swift
//  kasacle-app
//
//  Created by 笠原涼太 on 2026/02/13.
//

import SwiftUI
import SwiftData

// MARK: - WorkoutCalendarView

struct WorkoutCalendarView: View {
    /// 日付がタップされたときに呼ばれるコールバック（記録がある日のみ）
    var onDayTapped: ((Date) -> Void)? = nil

    /// 表示中の年月
    @State private var displayMonth: Date = Calendar.current.startOfDay(for: .now)

    /// SwiftData から取得したワークアウト実績
    @Query private var records: [WorkoutRecord]

    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 7)
    private let weekdayLabels = ["日", "月", "火", "水", "木", "金", "土"]
    /// 日付セルの一辺のサイズ
    private let cellSize: CGFloat = 40

    // 表示月のワークアウト日セット
    private var workoutDays: Set<Date> {
        Set(records.map { calendar.startOfDay(for: $0.date) })
    }

    // 表示月の1日
    private var firstDayOfMonth: Date {
        let comps = calendar.dateComponents([.year, .month], from: displayMonth)
        return calendar.date(from: comps)!
    }

    // グリッドに並べる日付（前月の余白 nil + 当月の日付）
    private var gridDays: [Date?] {
        let weekdayOfFirst = calendar.component(.weekday, from: firstDayOfMonth) - 1
        let daysInMonth = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!.count
        var days: [Date?] = Array(repeating: nil, count: weekdayOfFirst)
        for day in 1...daysInMonth {
            let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)!
            days.append(date)
        }
        return days
    }

    private var monthTitle: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ja_JP")
        f.dateFormat = "yyyy年M月"
        return f.string(from: displayMonth)
    }

    private var isCurrentMonth: Bool {
        calendar.isDate(displayMonth, equalTo: .now, toGranularity: .month)
    }

    var body: some View {
        VStack(spacing: 0) {
            // ─── ヘッダー（月移動） ───────────────────────────
            HStack {
                Button {
                    changeMonth(by: -1)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(AppColor.brand)
                        .padding(8)
                }

                Spacer()

                Text(monthTitle)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(AppColor.onSurface)

                Spacer()

                Button {
                    changeMonth(by: 1)
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(isCurrentMonth ? AppColor.onSurface.opacity(0.25) : AppColor.brand)
                        .padding(8)
                }
                .disabled(isCurrentMonth)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 12)

            // ─── 曜日ラベル ───────────────────────────────────
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(weekdayLabels, id: \.self) { label in
                    Text(label)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(
                            label == "日"
                                ? Color(red: 0.9, green: 0.25, blue: 0.25).opacity(0.85)
                                : label == "土"
                                    ? Color(red: 0.10, green: 0.45, blue: 0.85).opacity(0.85)
                                    : AppColor.onSurface.opacity(0.5)
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 8)
                }
            }

            // ─── 日付グリッド ──────────────────────────────────
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(Array(gridDays.enumerated()), id: \.offset) { _, date in
                    if let date {
                        let hasWorkout = workoutDays.contains(calendar.startOfDay(for: date))
                        Button {
                            if hasWorkout {
                                onDayTapped?(calendar.startOfDay(for: date))
                            }
                        } label: {
                            DayCell(
                                date: date,
                                hasWorkout: hasWorkout,
                                isToday: calendar.isDateInToday(date),
                                size: cellSize
                            )
                        }
                        .buttonStyle(.plain)
                    } else {
                        Color.clear
                            .frame(width: cellSize, height: cellSize)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(AppColor.onSurface.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(AppColor.onSurface.opacity(0.08), lineWidth: 1)
                )
        )
    }

    private func changeMonth(by value: Int) {
        guard let next = Calendar.current.date(
            byAdding: .month, value: value, to: displayMonth
        ) else { return }
        // 未来月には進めない
        if value > 0, Calendar.current.compare(next, to: .now, toGranularity: .month) == .orderedDescending {
            return
        }
        displayMonth = next
    }
}

// MARK: - DayCell

private struct DayCell: View {
    let date: Date
    let hasWorkout: Bool
    let isToday: Bool
    var size: CGFloat = 40

    private var dayNumber: String {
        "\(Calendar.current.component(.day, from: date))"
    }

    var body: some View {
        ZStack {
            if hasWorkout {
                // 実績あり：ブランドカラーの円
                Circle()
                    .fill(AppColor.brand)
            }
            if isToday {
                // 今日：枠線
                Circle()
                    .strokeBorder(AppColor.brand, lineWidth: 1.5)
            }

            Text(dayNumber)
                .font(.system(size: 13, weight: hasWorkout ? .bold : .regular))
                .foregroundStyle(
                    hasWorkout
                        ? AppColor.onBrand
                        : AppColor.onSurface.opacity(0.6)
                )
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    WorkoutCalendarView()
        .padding()
        .background(Color.white)
        .modelContainer(for: WorkoutRecord.self, inMemory: true)
}
