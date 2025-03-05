//
//  OnboardingRepository.swift
//  OnboardingAI iOS
//
//  Created by nrsys on 01/03/25.
//

import Foundation

extension OnboardingView {
    final class OnboardingRepository: OnboardingRepositoryProtocol {
        private let jsonDecoder = JSONDecoder()
        
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
        
        func verifyUser(_ uuid: String) async -> String? {
            do {
                let (data, _ ) = try await URLSessionManager.post(url: "https://api-dev.asah.dev/users/verify", headers: ["Authorization": "Bearer ANONYMOUS\(uuid)", "Content-Type": "application/json"])
                let responseString = String(data: data, encoding: String.Encoding.utf8)
                let verifyResponse = try jsonDecoder.decode(VerifyReponseCodable.self, from: (responseString?.data(using: .utf8))!)
                return verifyResponse.id_token
            } catch {
                // do nothing
            }
            return nil
        }
        
        func streamAudio(voiceId: Int, stepId: Int, audioFormat: Int, jwtToken: String) async -> URLSession.AsyncBytes? {
            do {
                let body = """
{
    "voice_id": \(voiceId),
    "step_id": \(stepId),
    "audio_format":"pcm"
}
""".data(using: .utf8)!
                let (bytes, _) = try await URLSessionManager.streamBytes(url: "https://api-dev.asah.dev/conversations/onboarding/speech", headers: ["Authorization": "Bearer \(jwtToken)"], method: "POST", body: body)
                print(bytes)
                return bytes
            } catch {
                // do nothing
            }
            return nil
        }
    }
}
