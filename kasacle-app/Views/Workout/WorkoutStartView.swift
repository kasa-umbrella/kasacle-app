//
//  WorkoutStartView.swift
//  kasacle-app
//
//  Created by 笠原涼太 on 2026/02/13.
//

import SwiftUI
import SwiftData

// MARK: - 画面フェーズ

private enum WorkoutPhase: Equatable {
    /// 部位・種目選択
    case setup
    /// セット計測中
    case tracking(setNumber: Int)
    /// セット後の入力（回数・重量）
    case logging(setNumber: Int, durationSeconds: Int, isFinishing: Bool)
    /// インターバル中
    case interval(setNumber: Int)
    /// 全セット完了・サマリー
    case summary
}

// MARK: - WorkoutStartView

struct WorkoutStartView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \CustomExercise.order) private var allExercises: [CustomExercise]

    // ─── 選択状態 ───────────────────────────────────────
    @State private var selectedGroup: MuscleGroup? = nil
    @State private var selectedExercise: String? = nil

    // ─── フェーズ ────────────────────────────────────────
    @State private var phase: WorkoutPhase = .setup

    // ─── 計測用タイマー ──────────────────────────────────
    @State private var elapsedSeconds: Int = 0
    @State private var timerTask: Task<Void, Never>? = nil

    // ─── インターバルタイマー ─────────────────────────────
    @State private var intervalSeconds: Int = 0
    @State private var intervalTask: Task<Void, Never>? = nil

    // ─── セット記録（完了分） ─────────────────────────────
    @State private var completedSets: [WorkoutSet] = []

    var body: some View {
        ZStack {
            AppColor.appBackground.ignoresSafeArea()

            switch phase {
            case .setup:
                SetupView(
                    selectedGroup: $selectedGroup,
                    selectedExercise: $selectedExercise,
                    allExercises: allExercises,
                    onStart: startFirstSet
                )

            case .tracking(let setNum):
                TrackingView(
                    setNumber: setNum,
                    exerciseName: selectedExercise ?? "",
                    elapsed: elapsedSeconds,
                    onInterval: { beginLogging(setNum: setNum, isFinishing: false) },
                    onFinish: { beginLogging(setNum: setNum, isFinishing: true) }
                )

            case .logging(let setNum, let duration, let isFinishing):
                LoggingView(
                    setNumber: setNum,
                    durationSeconds: duration,
                    isFinishing: isFinishing,
                    onConfirm: { reps, weight in
                        confirmSet(setNum: setNum, reps: reps, weight: weight,
                                   duration: duration, isFinishing: isFinishing)
                    }
                )

            case .interval(let nextSetNum):
                IntervalView(
                    nextSetNumber: nextSetNum,
                    intervalSeconds: intervalSeconds,
                    onNextSet: { startSet(setNumber: nextSetNum) }
                )

            case .summary:
                SummaryView(
                    muscleGroup: selectedGroup?.name ?? "",
                    exerciseName: selectedExercise ?? "",
                    sets: completedSets,
                    onSave: saveAndDismiss,
                    onDiscard: { dismiss() }
                )
            }
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(phase != .setup)
        .onAppear { seedDefaultExercises(context: context) }
        .onDisappear { stopAllTimers() }
    }

    private var navigationTitle: String {
        switch phase {
        case .setup:             return "ワークアウト開始"
        case .tracking(let n):  return "セット \(n) 計測中"
        case .logging(let n, _, _): return "セット \(n) 記録"
        case .interval:         return "インターバル"
        case .summary:          return "セッション完了"
        }
    }

    // MARK: - アクション

    private func startFirstSet() {
        startSet(setNumber: 1)
    }

    private func startSet(setNumber: Int) {
        timerTask?.cancel()
        timerTask = nil
        intervalTask?.cancel()
        intervalTask = nil
        elapsedSeconds = 0
        phase = .tracking(setNumber: setNumber)
        timerTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                if !Task.isCancelled { elapsedSeconds += 1 }
            }
        }
    }

    private func beginLogging(setNum: Int, isFinishing: Bool) {
        timerTask?.cancel()
        timerTask = nil
        phase = .logging(setNumber: setNum, durationSeconds: elapsedSeconds, isFinishing: isFinishing)
    }

    private func confirmSet(setNum: Int, reps: Int, weight: Double?,
                            duration: Int, isFinishing: Bool) {
        let set = WorkoutSet(setNumber: setNum, reps: reps, weightKg: weight,
                             durationSeconds: duration)
        completedSets.append(set)

        if isFinishing {
            phase = .summary
        } else {
            intervalTask?.cancel()
            intervalTask = nil
            intervalSeconds = 0
            phase = .interval(setNumber: setNum + 1)
            intervalTask = Task {
                while !Task.isCancelled {
                    try? await Task.sleep(for: .seconds(1))
                    if !Task.isCancelled { intervalSeconds += 1 }
                }
            }
        }
    }

    private func saveAndDismiss() {
        guard let group = selectedGroup, let exercise = selectedExercise else { return }

        // 今日の WorkoutRecord を探すか新規作成
        let today = Calendar.current.startOfDay(for: .now)
        let descriptor = FetchDescriptor<WorkoutRecord>(
            predicate: #Predicate { $0.date == today }
        )
        let existing = try? context.fetch(descriptor)
        let record: WorkoutRecord
        if let found = existing?.first {
            record = found
        } else {
            record = WorkoutRecord(date: today)
            context.insert(record)
        }

        let session = WorkoutSession(
            muscleGroup: group.name,
            exerciseName: exercise
        )
        session.finishedAt = .now
        session.sets = completedSets
        context.insert(session)
        record.sessions.append(session)

        try? context.save()
        dismiss()
    }

    private func stopAllTimers() {
        timerTask?.cancel()
        intervalTask?.cancel()
    }
}

// MARK: - SetupView（部位・種目選択）

private struct SetupView: View {
    @Binding var selectedGroup: MuscleGroup?
    @Binding var selectedExercise: String?
    let allExercises: [CustomExercise]
    let onStart: () -> Void

    var canStart: Bool { selectedGroup != nil && selectedExercise != nil }

    private var exercisesForGroup: [CustomExercise] {
        guard let group = selectedGroup else { return [] }
        return allExercises
            .filter { $0.muscleGroupName == group.name }
            .sorted { $0.order < $1.order }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // ─── 部位選択 ─────────────────────────────────
                SectionCard(title: "部位を選ぶ", icon: "figure.strengthtraining.functional") {
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3),
                        spacing: 10
                    ) {
                        ForEach(muscleGroups) { group in
                            MuscleGroupChip(
                                group: group,
                                isSelected: selectedGroup?.id == group.id
                            ) {
                                selectedGroup = group
                                selectedExercise = nil
                            }
                        }
                    }
                }

                // ─── 種目選択 ─────────────────────────────────
                if selectedGroup != nil {
                    SectionCard(title: "種目を選ぶ", icon: "dumbbell.fill") {
                        VStack(spacing: 8) {
                            ForEach(exercisesForGroup) { ex in
                                ExerciseRow(
                                    name: ex.exerciseName,
                                    isSelected: selectedExercise == ex.exerciseName
                                ) {
                                    selectedExercise = ex.exerciseName
                                }
                            }
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                // ─── 開始ボタン ───────────────────────────────
                Button(action: onStart) {
                    Label("開始する", systemImage: "flame.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(canStart ? AppColor.onBrand : AppColor.onSurface.opacity(0.35))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(canStart ? AppColor.brand : AppColor.onSurface.opacity(0.07))
                        )
                }
                .disabled(!canStart)
                .animation(.easeInOut(duration: 0.2), value: canStart)

                Spacer(minLength: 32)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
        .animation(.easeInOut(duration: 0.25), value: selectedGroup?.id)
    }
}

// MARK: - TrackingView（計測中）

private struct TrackingView: View {
    let setNumber: Int
    let exerciseName: String
    let elapsed: Int
    let onInterval: () -> Void
    let onFinish: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // セット番号
            Text("セット \(setNumber)")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(AppColor.onSurface.opacity(0.5))

            // 種目名
            Text(exerciseName)
                .font(.system(size: 26, weight: .black))
                .foregroundStyle(AppColor.onSurface)

            // タイマー表示
            Text(formatTime(elapsed))
                .font(.system(size: 72, weight: .black, design: .monospaced))
                .foregroundStyle(AppColor.brand)
                .contentTransition(.numericText())
                .animation(.linear(duration: 0.3), value: elapsed)

            Spacer()

            // アクションボタン
            VStack(spacing: 14) {
                Button(action: onInterval) {
                    Label("インターバルへ", systemImage: "pause.circle.fill")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(AppColor.onBrand)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(AppColor.brand)
                        )
                }

                Button(action: onFinish) {
                    Label("トレーニング終了", systemImage: "stop.circle.fill")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(AppColor.onSurface.opacity(0.6))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(AppColor.onSurface.opacity(0.07))
                        )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - LoggingView（回数・重量入力）

private struct LoggingView: View {
    let setNumber: Int
    let durationSeconds: Int
    let isFinishing: Bool
    let onConfirm: (Int, Double?) -> Void

    @State private var reps: Int = 10
    @State private var weight: String = ""
    @State private var isBodyweight: Bool = false

    private var parsedWeight: Double? {
        isBodyweight ? nil : Double(weight)
    }

    private var canConfirm: Bool {
        reps > 0 && (isBodyweight || !weight.isEmpty)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // ─── ヘッダー情報 ──────────────────────────
                HStack(spacing: 20) {
                    InfoBadge(
                        icon: "timer",
                        label: "計測時間",
                        value: formatTime(durationSeconds)
                    )
                    InfoBadge(
                        icon: "number",
                        label: "セット",
                        value: "\(setNumber)"
                    )
                }
                .padding(.top, 8)

                // ─── 回数入力 ──────────────────────────────
                SectionCard(title: "回数", icon: "repeat") {
                    HStack(spacing: 20) {
                        StepperButton(icon: "minus", action: { if reps > 1 { reps -= 1 } })
                        Text("\(reps)")
                            .font(.system(size: 48, weight: .black, design: .rounded))
                            .foregroundStyle(AppColor.onSurface)
                            .frame(minWidth: 80)
                            .contentTransition(.numericText())
                            .animation(.spring(duration: 0.2), value: reps)
                        StepperButton(icon: "plus", action: { reps += 1 })
                    }
                    .frame(maxWidth: .infinity)
                }

                // ─── 重量入力 ──────────────────────────────
                SectionCard(title: "重量", icon: "scalemass.fill") {
                    VStack(spacing: 14) {
                        Toggle(isOn: $isBodyweight) {
                            Label("自重（重量なし）", systemImage: "figure.stand")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(AppColor.onSurface)
                        }
                        .tint(AppColor.brand)

                        if !isBodyweight {
                            HStack(spacing: 8) {
                                TextField("0.0", text: $weight)
                                    .keyboardType(.decimalPad)
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundStyle(AppColor.onSurface)
                                    .multilineTextAlignment(.trailing)
                                    .frame(maxWidth: .infinity)
                                Text("kg")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(AppColor.onSurface.opacity(0.5))
                            }
                            .padding(.horizontal, 8)
                        }
                    }
                }

                // ─── 確定ボタン ────────────────────────────
                Button {
                    onConfirm(reps, parsedWeight)
                } label: {
                    Label(
                        isFinishing ? "完了して終わる" : "記録してインターバルへ",
                        systemImage: isFinishing ? "checkmark.circle.fill" : "arrow.right.circle.fill"
                    )
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(canConfirm ? AppColor.onBrand : AppColor.onSurface.opacity(0.35))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(canConfirm ? AppColor.brand : AppColor.onSurface.opacity(0.07))
                    )
                }
                .disabled(!canConfirm)

                Spacer(minLength: 32)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
    }
}

// MARK: - IntervalView（インターバル）

private struct IntervalView: View {
    let nextSetNumber: Int
    let intervalSeconds: Int
    let onNextSet: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Text("インターバル")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(AppColor.onSurface.opacity(0.5))

            Text(formatTime(intervalSeconds))
                .font(.system(size: 72, weight: .black, design: .monospaced))
                .foregroundStyle(AppColor.brand)
                .contentTransition(.numericText())
                .animation(.linear(duration: 0.3), value: intervalSeconds)

            Text("休憩中…")
                .font(.system(size: 15))
                .foregroundStyle(AppColor.onSurface.opacity(0.4))

            Spacer()

            Button(action: onNextSet) {
                Label("セット \(nextSetNumber) を開始", systemImage: "play.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(AppColor.onBrand)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(AppColor.brand)
                    )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - SummaryView（完了サマリー）

private struct SummaryView: View {
    let muscleGroup: String
    let exerciseName: String
    let sets: [WorkoutSet]
    let onSave: () -> Void
    let onDiscard: () -> Void

    private var totalReps: Int { sets.reduce(0) { $0 + $1.reps } }
    private var totalTime: Int { sets.reduce(0) { $0 + $1.durationSeconds } }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // ─── タイトル ──────────────────────────────
                VStack(spacing: 6) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 52))
                        .foregroundStyle(AppColor.brand)
                    Text("お疲れ様でした！")
                        .font(.system(size: 22, weight: .black))
                        .foregroundStyle(AppColor.onSurface)
                    Text("\(muscleGroup) / \(exerciseName)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(AppColor.onSurface.opacity(0.5))
                }
                .padding(.top, 16)

                // ─── 合計サマリー ──────────────────────────
                HStack(spacing: 16) {
                    InfoBadge(icon: "list.number", label: "総セット", value: "\(sets.count)")
                    InfoBadge(icon: "repeat",       label: "総回数",   value: "\(totalReps)回")
                    InfoBadge(icon: "timer",        label: "総時間",   value: formatTime(totalTime))
                }

                // ─── セット別詳細 ──────────────────────────
                SectionCard(title: "セット記録", icon: "tablecells") {
                    VStack(spacing: 0) {
                        ForEach(Array(sets.enumerated()), id: \.offset) { i, set in
                            HStack {
                                Text("セット \(set.setNumber)")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(AppColor.onSurface.opacity(0.5))
                                Spacer()
                                if let w = set.weightKg {
                                    Text("\(w, specifier: "%.1f") kg")
                                        .foregroundStyle(AppColor.onSurface)
                                } else {
                                    Text("自重")
                                        .foregroundStyle(AppColor.onSurface.opacity(0.6))
                                }
                                Text("×")
                                    .foregroundStyle(AppColor.onSurface.opacity(0.35))
                                    .padding(.horizontal, 4)
                                Text("\(set.reps) 回")
                                    .foregroundStyle(AppColor.onSurface)
                                Text(formatTime(set.durationSeconds))
                                    .font(.system(size: 13, design: .monospaced))
                                    .foregroundStyle(AppColor.onSurface.opacity(0.4))
                                    .padding(.leading, 8)
                            }
                            .font(.system(size: 15, weight: .medium))
                            .padding(.vertical, 10)

                            if i < sets.count - 1 {
                                Divider().overlay(AppColor.onSurface.opacity(0.10))
                            }
                        }
                    }
                }

                // ─── 保存 / 破棄ボタン ─────────────────────
                VStack(spacing: 12) {
                    Button(action: onSave) {
                        Label("記録を保存する", systemImage: "square.and.arrow.down.fill")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(AppColor.onBrand)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(AppColor.brand)
                            )
                    }

                    Button(action: onDiscard) {
                        Text("保存せず終了")
                            .font(.system(size: 15))
                            .foregroundStyle(AppColor.onSurface.opacity(0.4))
                    }
                }

                Spacer(minLength: 32)
            }
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - 共通コンポーネント

private struct SectionCard<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label(title, systemImage: icon)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(AppColor.onSurface.opacity(0.5))

            content()
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(AppColor.onSurface.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(AppColor.onSurface.opacity(0.08), lineWidth: 1)
                )
        )
    }
}

private struct MuscleGroupChip: View {
    let group: MuscleGroup
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: group.icon)
                    .font(.system(size: 22))
                    .frame(height: 28)
                Text(group.name)
                    .font(.system(size: 13, weight: .semibold))
            }
            .foregroundStyle(isSelected ? AppColor.onBrand : AppColor.onSurface.opacity(0.6))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(isSelected ? AppColor.brand : AppColor.onSurface.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .strokeBorder(
                                isSelected ? AppColor.brand : AppColor.onSurface.opacity(0.10),
                                lineWidth: 1.5
                            )
                    )
            )
            .animation(.easeInOut(duration: 0.15), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

private struct ExerciseRow: View {
    let name: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(name)
                    .font(.system(size: 16, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? AppColor.brand : AppColor.onSurface.opacity(0.7))
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(AppColor.brand)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(isSelected ? AppColor.brand.opacity(0.08) : AppColor.onSurface.opacity(0.04))
            )
            .animation(.easeInOut(duration: 0.15), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

private struct StepperButton: View {
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(AppColor.brand)
                .frame(width: 52, height: 52)
                .background(
                    Circle().fill(AppColor.brand.opacity(0.10))
                )
        }
        .buttonStyle(.plain)
    }
}

private struct InfoBadge: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(AppColor.onSurface.opacity(0.45))
            Text(value)
                .font(.system(size: 18, weight: .black, design: .rounded))
                .foregroundStyle(AppColor.onSurface)
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(AppColor.onSurface.opacity(0.45))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppColor.onSurface.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(AppColor.onSurface.opacity(0.08), lineWidth: 1)
                )
        )
    }
}

// MARK: - ユーティリティ

private func formatTime(_ seconds: Int) -> String {
    let m = seconds / 60
    let s = seconds % 60
    return String(format: "%02d:%02d", m, s)
}

// MARK: - Preview

#Preview {
    NavigationStack {
        WorkoutStartView()
    }
    .modelContainer(for: [WorkoutRecord.self, WorkoutSession.self, WorkoutSet.self], inMemory: true)
}
