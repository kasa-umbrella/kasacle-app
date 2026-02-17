//
//  WorkoutStartView.swift
//  kasacle-app
//
//  Created by 笠原涼太 on 2026/02/13.
//

import SwiftUI

struct WorkoutStartView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "dumbbell.fill")
                    .font(.system(size: 72))
                    .foregroundStyle(.tint)

                Text("筋トレを開始する")
                    .font(.title2.bold())

                Text("ここに種目・セット数・重量などを記録します")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .navigationTitle("筋トレ開始")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("閉じる") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    WorkoutStartView()
}
