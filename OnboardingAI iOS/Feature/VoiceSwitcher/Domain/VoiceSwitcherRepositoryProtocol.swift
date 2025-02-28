//
//  VoiceSwitcherRepositoryProtocol.swift
//  OnboardingAI iOS
//
//  Created by nrsys on 28/02/25.
//

import Foundation

protocol VoiceSwitcherRepositoryProtocol : Sendable {
    func getVoiceItems() -> [VoiceItemIdentifiable]
    func fetchVoiceFile(voiceId: Int, voiceSampleId: Int) async throws -> URL?
}
