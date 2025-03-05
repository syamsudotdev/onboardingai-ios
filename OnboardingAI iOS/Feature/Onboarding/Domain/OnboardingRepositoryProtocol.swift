//
//  OnboardingRepositoryProtocol.swift
//  OnboardingAI iOS
//
//  Created by nrsys on 01/03/25.
//

import Foundation

protocol OnboardingRepositoryProtocol: Sendable {
  func getFileUri(_ voiceId: Int, _ voiceSampleId: Int) -> URL?
  func getTranscription(_ voiceId: Int, _ voiceSampleId: Int) async -> String?
  func verifyUser(_ uuid: String) async -> String?
    func streamAudio(voiceId: Int, stepId: Int, audioFormat: Int, jwtToken: String) async -> URLSession.AsyncBytes?
}
