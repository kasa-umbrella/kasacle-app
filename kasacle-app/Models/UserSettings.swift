//
//  UserSettings.swift
//  kasacle-app
//
//  Created by 笠原涼太 on 2026/02/18.
//

import Foundation
import Observation

/// ユーザーの体重・身長などの設定を管理するクラス
@Observable
final class UserSettings {
    /// シングルトンインスタンス
    static let shared = UserSettings()

    private let defaults = UserDefaults.standard

    private enum Keys {
        static let weight = "user_weight"
        static let height = "user_height"
    }

    /// 体重（kg）
    var weight: Double {
        didSet {
            defaults.set(weight, forKey: Keys.weight)
        }
    }

    /// 身長（cm）
    var height: Double {
        didSet {
            defaults.set(height, forKey: Keys.height)
        }
    }

    /// BMI（体重と身長から自動計算）
    var bmi: Double? {
        guard height > 0, weight > 0 else { return nil }
        let heightInMeters = height / 100.0
        return weight / (heightInMeters * heightInMeters)
    }

    /// BMIのカテゴリ
    var bmiCategory: String {
        guard let bmi = bmi else { return "未設定" }
        switch bmi {
        case ..<18.5:
            return "低体重"
        case 18.5..<25:
            return "普通体重"
        case 25..<30:
            return "肥満（1度）"
        case 30...:
            return "肥満（2度以上）"
        default:
            return "未設定"
        }
    }

    private init() {
        self.weight = defaults.double(forKey: Keys.weight)
        self.height = defaults.double(forKey: Keys.height)
    }

    /// 設定がまだ入力されていないかどうか
    var isInitialSetup: Bool {
        weight == 0 && height == 0
    }
}
