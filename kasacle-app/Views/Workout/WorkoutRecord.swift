//
//  WorkoutRecord.swift
//  kasacle-app
//
//  Created by 笠原涼太 on 2026/02/13.
//

import Foundation
import SwiftData

// MARK: - WorkoutRecord

/// 1日のワークアウトをまとめるモデル
@Model
final class WorkoutRecord {
    /// ワークアウトを行った日付（日単位で管理）
    var date: Date
    /// その日に行ったセッション群
    @Relationship(deleteRule: .cascade)
    var sessions: [WorkoutSession]

    init(date: Date = .now) {
        self.date = Calendar.current.startOfDay(for: date)
        self.sessions = []
    }
}

// MARK: - WorkoutSession

/// 1種目分のセッション（複数セットを持つ）
@Model
final class WorkoutSession {
    /// 部位（例: "胸", "背中"）
    var muscleGroup: String
    /// 種目名（例: "ベンチプレス"）
    var exerciseName: String
    /// セッション開始日時
    var startedAt: Date
    /// セッション終了日時
    var finishedAt: Date?
    /// 各セットの記録
    @Relationship(deleteRule: .cascade)
    var sets: [WorkoutSet]

    init(muscleGroup: String, exerciseName: String) {
        self.muscleGroup = muscleGroup
        self.exerciseName = exerciseName
        self.startedAt = .now
        self.finishedAt = nil
        self.sets = []
    }
}

// MARK: - WorkoutSet

/// 1セット分の記録
@Model
final class WorkoutSet {
    /// セット番号（1始まり）
    var setNumber: Int
    /// 回数
    var reps: Int
    /// 重量（kg）、自重の場合は nil
    var weightKg: Double?
    /// このセットの計測時間（秒）
    var durationSeconds: Int

    init(setNumber: Int, reps: Int, weightKg: Double?, durationSeconds: Int) {
        self.setNumber = setNumber
        self.reps = reps
        self.weightKg = weightKg
        self.durationSeconds = durationSeconds
    }
}

// MARK: - 部位・種目マスタ

struct MuscleGroup: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let exercises: [String]
}

let muscleGroups: [MuscleGroup] = [
    MuscleGroup(name: "胸", icon: "figure.arms.open", exercises: [
        "ベンチプレス", "インクラインベンチプレス", "ダンベルフライ",
        "ケーブルクロスオーバー", "ディップス", "プッシュアップ"
    ]),
    MuscleGroup(name: "背中", icon: "figure.strengthtraining.traditional", exercises: [
        "デッドリフト", "懸垂（チンアップ）", "ラットプルダウン",
        "シーテッドロウ", "ベントオーバーロウ", "ワンハンドロウ"
    ]),
    MuscleGroup(name: "肩", icon: "figure.boxing", exercises: [
        "ショルダープレス", "サイドレイズ", "フロントレイズ",
        "リアレイズ", "フェイスプル", "アーノルドプレス"
    ]),
    MuscleGroup(name: "腕", icon: "figure.handball", exercises: [
        "バーベルカール", "ダンベルカール", "ハンマーカール",
        "トライセプスプッシュダウン", "スカルクラッシャー", "ディップス"
    ]),
    MuscleGroup(name: "脚", icon: "figure.run", exercises: [
        "スクワット", "レッグプレス", "レッグカール",
        "レッグエクステンション", "ルーマニアンデッドリフト", "カーフレイズ"
    ]),
    MuscleGroup(name: "腹", icon: "figure.core.training", exercises: [
        "クランチ", "レッグレイズ", "プランク",
        "ロシアンツイスト", "アブローラー", "ハンギングニーレイズ"
    ]),
]
