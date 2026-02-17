//
//  WorkoutRecord.swift
//  kasacle-app
//
//  Created by 笠原涼太 on 2026/02/13.
//

import Foundation
import SwiftData

/// 1回のワークアウトを表すモデル
@Model
final class WorkoutRecord {
    /// ワークアウトを行った日付（時刻は切り捨てて日単位で管理）
    var date: Date
    /// ワークアウトのメモ（任意）
    var note: String

    init(date: Date = .now, note: String = "") {
        // 日単位に正規化
        self.date = Calendar.current.startOfDay(for: date)
        self.note = note
    }
}
