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
    /// 背景色（メインカラーと同色）
    static let appBackground = brand
    /// 背景上のテキスト：とても濃い紺色
    static let onBackground = Color(red: 0 / 255, green: 20 / 255, blue: 60 / 255)
    /// メインカラー上のテキスト：非常に薄い水色
    static let onBrand = Color(red: 235 / 255, green: 247 / 255, blue: 255 / 255).opacity(0.75)
}
