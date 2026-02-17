//
//  SettingsView.swift
//  kasacle-app
//
//  Created by 笠原涼太 on 2026/02/18.
//

import SwiftUI
import SwiftData

// MARK: - SettingsView

struct SettingsView: View {
    @Environment(\.modelContext) private var context
    @Query private var allExercises: [CustomExercise]

    var body: some View {
        ZStack {
            AppColor.appBackground.ignoresSafeArea()

            List {
                Section {
                    ForEach(muscleGroups) { group in
                        NavigationLink {
                            ExerciseListView(muscleGroupName: group.name)
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: group.icon)
                                    .font(.system(size: 18))
                                    .foregroundStyle(AppColor.brand)
                                    .frame(width: 28)
                                Text(group.name)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(AppColor.onSurface)
                                Spacer()
                                Text("\(exerciseCount(for: group.name))種目")
                                    .font(.system(size: 13))
                                    .foregroundStyle(AppColor.onSurface.opacity(0.4))
                            }
                        }
                    }
                } header: {
                    Text("種目の管理")
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("設定")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { seedDefaultExercises(context: context) }
    }

    private func exerciseCount(for groupName: String) -> Int {
        allExercises.filter { $0.muscleGroupName == groupName }.count
    }
}

// MARK: - ExerciseListView

struct ExerciseListView: View {
    let muscleGroupName: String

    @Environment(\.modelContext) private var context
    @Query private var allExercises: [CustomExercise]

    @State private var showAddAlert = false
    @State private var newExerciseName = ""

    private var exercises: [CustomExercise] {
        allExercises
            .filter { $0.muscleGroupName == muscleGroupName }
            .sorted { $0.order < $1.order }
    }

    var body: some View {
        ZStack {
            AppColor.appBackground.ignoresSafeArea()

            List {
                Section {
                    ForEach(exercises) { exercise in
                        HStack {
                            Text(exercise.exerciseName)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(AppColor.onSurface)
                        }
                    }
                    .onDelete(perform: deleteExercises)
                } footer: {
                    if exercises.isEmpty {
                        Text("種目がありません。右上の＋ボタンから追加してください。")
                            .foregroundStyle(AppColor.onSurface.opacity(0.4))
                    }
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle(muscleGroupName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    newExerciseName = ""
                    showAddAlert = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(AppColor.brand)
                }
            }
        }
        .alert("種目を追加", isPresented: $showAddAlert) {
            TextField("種目名", text: $newExerciseName)
            Button("追加") { addExercise() }
            Button("キャンセル", role: .cancel) {}
        } message: {
            Text("\(muscleGroupName)に追加する種目名を入力してください。")
        }
    }

    private func addExercise() {
        let name = newExerciseName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }

        let nextOrder = (exercises.map(\.order).max() ?? -1) + 1
        let item = CustomExercise(
            muscleGroupName: muscleGroupName,
            exerciseName: name,
            order: nextOrder
        )
        context.insert(item)
        try? context.save()
    }

    private func deleteExercises(at offsets: IndexSet) {
        for index in offsets {
            context.delete(exercises[index])
        }
        try? context.save()
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        SettingsView()
    }
    .modelContainer(for: [CustomExercise.self], inMemory: true)
}
