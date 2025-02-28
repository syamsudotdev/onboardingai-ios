//
//  VoiceSwitcherRepository.swift
//  OnboardingAI iOS
//
//  Created by nrsys on 28/02/25.
//
import Foundation

extension VoiceSwitcherView {
    final class VoiceSwitcherRepository: VoiceSwitcherRepositoryProtocol {
        func getVoiceItems() -> [VoiceItemIdentifiable] {
            let items: [VoiceItemIdentifiable] = [
                "https://static.dailyfriend.ai/images/voices/meadow.svg",
                "https://static.dailyfriend.ai/images/voices/cypress.svg",
                "https://static.dailyfriend.ai/images/voices/iris.svg",
                "https://static.dailyfriend.ai/images/voices/hawke.svg",
                "https://static.dailyfriend.ai/images/voices/seren.svg",
                "https://static.dailyfriend.ai/images/voices/stone.svg",
            ].enumerated().map { x, s in
                let name: String = String(s.split(separator: "/").last?.split(separator: ".").first ?? "")
                return VoiceItemIdentifiable(id: x + 1, name: name, iconUri: s, isActive: false)
            }
            return items
        }

        func fetchVoiceFile(voiceId: Int, voiceSampleId: Int) async -> URL? {
            let url = URL(string: "https://static.dailyfriend.ai/conversations/samples/\(voiceId)/\(voiceSampleId)/audio.mp3")!
            let destination = createVoiceCacheFile(voiceId, voiceSampleId)
            guard let destination = destination else {
                print("Error creating cache file")
                return nil
            }
            if (FileManager.default.fileExists(atPath: destination.path)) {
                return destination
            }
            do {
                let (data, response) = try await URLSession.shared.download(from: url)
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                if statusCode >= 200 && statusCode < 300 {
                    try FileManager.default.moveItem(at: data, to: destination)
                    return destination
                }
                throw NSError(domain: "HTTP Error", code: statusCode, userInfo: nil)
            } catch {
                print("Error fetching voice file: \(error)")
                return nil
            }
        }

        private func createVoiceCacheFile(_ voiceId: Int, _ voiceSampleId: Int) -> URL? {
            let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            var destination = cacheDirectory.appendingPathComponent("voices")
            if (!FileManager.default.fileExists(atPath: destination.path)) {
                try? FileManager.default.createDirectory(at: destination, withIntermediateDirectories: true, attributes: nil)
            }
            destination = destination.appendingPathComponent("\(voiceId)_\(voiceSampleId).mp3")
            return destination
        }
    }
}
