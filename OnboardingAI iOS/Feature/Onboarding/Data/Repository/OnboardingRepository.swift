//
//  OnboardingRepository.swift
//  OnboardingAI iOS
//
//  Created by nrsys on 01/03/25.
//

import Foundation

extension OnboardingView {
  final class OnboardingRepository: OnboardingRepositoryProtocol {
    func getFileUri(_ voiceId: Int, _ voiceSampleId: Int) -> URL? {
      getVoiceCacheFile(voiceId, voiceSampleId)
    }

    func getTranscription(_ voiceId: Int, _ voiceSampleId: Int) async -> String? {
      do {
        let (data, response) = try await URLSessionManager.get(
          path: "conversations/samples/\(voiceId)/\(voiceSampleId)/transcription.txt")
        let responseHttp = response as? HTTPURLResponse
        let statusCode = responseHttp?.statusCode ?? -1
        if statusCode >= 200 && statusCode < 300 {
          return String(data: data, encoding: .utf8)
        }
      } catch {
        // do nothing
      }
      return nil
    }

    private func getVoiceCacheFile(_ voiceId: Int, _ voiceSampleId: Int) -> URL? {
      let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        .first!
      let destination = cacheDirectory.appendingPathComponent("voices").appendingPathComponent(
        "\(voiceId)_\(voiceSampleId).mp3")
      if FileManager.default.fileExists(atPath: destination.path) {
        return destination
      }
      return nil
    }
  }
}
