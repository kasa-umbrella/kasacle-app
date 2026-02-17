//
//  SettingsView.swift
//  kasacle-app
//
//  Created by 笠原涼太 on 2026/02/18.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var settings = UserSettings.shared

    @State private var weightText: String = ""
    @State private var heightText: String = ""
    @State private var showingSaveConfirmation = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppColor.appBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // ── プロフィール設定 ──────────────────
                        VStack(alignment: .leading, spacing: 16) {
                            Text("プロフィール")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(AppColor.onBrand)

                            // 体重入力
                            VStack(alignment: .leading, spacing: 8) {
                                Label("体重", systemImage: "scalemass.fill")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(AppColor.onBrand.opacity(0.7))

                                HStack(spacing: 12) {
                                    TextField("例: 70", text: $weightText)
                                        .keyboardType(.decimalPad)
                                        .font(.system(size: 16))
                                        .foregroundStyle(AppColor.onBackground)
                                        .padding(12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .fill(Color.white)
                                        )

                                    Text("kg")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundStyle(AppColor.onBrand.opacity(0.7))
                                }
                            }

                            // 身長入力
                            VStack(alignment: .leading, spacing: 8) {
                                Label("身長", systemImage: "ruler.fill")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(AppColor.onBrand.opacity(0.7))

                                HStack(spacing: 12) {
                                    TextField("例: 170", text: $heightText)
                                        .keyboardType(.decimalPad)
                                        .font(.system(size: 16))
                                        .foregroundStyle(AppColor.onBackground)
                                        .padding(12)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .fill(Color.white)
                                        )

                                    Text("cm")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundStyle(AppColor.onBrand.opacity(0.7))
                                }
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color.white.opacity(0.12))
                        )

                        // ── BMI情報 ──────────────────────────
                        if let bmi = settings.bmi {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("BMI")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundStyle(AppColor.onBrand)

                                HStack(alignment: .firstTextBaseline, spacing: 8) {
                                    Text(String(format: "%.1f", bmi))
                                        .font(.system(size: 40, weight: .bold))
                                        .foregroundStyle(AppColor.onBrand)

                                    Text(settings.bmiCategory)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundStyle(AppColor.onBrand.opacity(0.7))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                .fill(Color.white.opacity(0.2))
                                        )
                                }

                                Text("BMI = 体重(kg) ÷ 身長(m)²")
                                    .font(.system(size: 13))
                                    .foregroundStyle(AppColor.onBrand.opacity(0.5))
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(Color.white.opacity(0.12))
                            )
                        }

                        // ── 保存ボタン ────────────────────────
                        Button {
                            saveSettings()
                        } label: {
                            Text("保存")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(AppColor.brand)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(Color.white)
                                )
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("閉じる") {
                        dismiss()
                    }
                    .foregroundStyle(AppColor.onBrand)
                }
            }
            .onAppear {
                loadSettings()
            }
            .alert("保存完了", isPresented: $showingSaveConfirmation) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("設定を保存しました")
            }
        }
    }

    private func loadSettings() {
        if settings.weight > 0 {
            weightText = String(format: "%.1f", settings.weight)
        }
        if settings.height > 0 {
            heightText = String(format: "%.1f", settings.height)
        }
    }

    private func saveSettings() {
        if let weight = Double(weightText) {
            settings.weight = weight
        }
        if let height = Double(heightText) {
            settings.height = height
        }
        showingSaveConfirmation = true
    }
}

#Preview {
    SettingsView()
}
