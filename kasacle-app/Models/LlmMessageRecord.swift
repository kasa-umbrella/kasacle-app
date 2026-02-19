//
//  LlmMessageRecord.swift
//  kasacle-app
//
//  Created by 笠原涼太 on 2026/02/19.
//

import Foundation
import FoundationModels
import SwiftData

// MARK: - LlmMessageRole

enum LlmMessageRole: String, Codable {
    case system
    case user
    case assistant
}

// MARK: - LlmMessageRecord

@Model
final class LlmMessageRecord {
    var roleRawValue: String
    var message: String
    var createdAt: Date

    init(role: LlmMessageRole, message: String, createdAt: Date = .now) {
        self.roleRawValue = role.rawValue
        self.message = message
        self.createdAt = createdAt
    }

    var role: LlmMessageRole {
        get { LlmMessageRole(rawValue: roleRawValue) ?? .assistant }
        set { roleRawValue = newValue.rawValue }
    }
}

// MARK: - WorkoutAdviceModel

@MainActor
struct WorkoutAdviceModel {
    private var session: LanguageModelSession

    init() {
        session = LanguageModelSession(
            instructions: """
                あなたは筋トレ習慣化を支援する日本語コーチです。
                回答は親しみやすく、前向きで、2文以内にしてください。
                医療行為や断定的な診断は行わないでください。
                """
        )
    }

    mutating func generateAdvice(from userPrompt: String, context: ModelContext? = nil) async throws
        -> String
    {
        if let context {
            context.insert(LlmMessageRecord(role: .user, message: userPrompt))
        }

        let response = try await session.respond(to: userPrompt)
        let text = response.content.trimmingCharacters(in: .whitespacesAndNewlines)

        if let context {
            context.insert(LlmMessageRecord(role: .assistant, message: text))
            try? context.save()
        }

        return text
    }
}
