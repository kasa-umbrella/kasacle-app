//
//  AppColor.swift
//  kasacle-app
//
//  Created by 笠原涼太 on 2026/02/13.
//

import SwiftUI

/// アプリ全体で使用するカラーパレット
enum AppColor {
    /// メインカラー #0067c0
    static let brand = Color(red: 0 / 255, green: 103 / 255, blue: 192 / 255)
    /// 背景色（白）
    static let appBackground = Color.white
    /// 背景上のテキスト：とても濃い紺色
    static let onBackground = Color(red: 0 / 255, green: 20 / 255, blue: 60 / 255)
    /// メインカラー上のテキスト：非常に薄い水色（brand色の上に載せるとき用）
    static let onBrand = Color.white
    /// 白背景上のテキスト・アイコン：濃い紺色
    static let onSurface = Color(red: 0 / 255, green: 20 / 255, blue: 60 / 255)
}
