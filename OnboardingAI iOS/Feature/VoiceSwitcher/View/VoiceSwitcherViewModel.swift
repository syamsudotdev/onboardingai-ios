//
//  VoiceSwitcherViewModel.swift
//  OnboardingAI iOS
//
//  Created by nrsys on 28/02/25.
//

import AVFoundation
import SwiftUI

extension VoiceSwitcherView {

  @MainActor
  @Observable
  final class ViewModel {

    private(set) var voiceItems: [VoiceItemIdentifiable] = []
    private(set) var voiceSampleId: Int = 0
    private let repository: VoiceSwitcherRepositoryProtocol
    private var player: AVAudioPlayer?
    var isPlaying: Bool {
      player?.isPlaying ?? false
    }

    init(
      repository: VoiceSwitcherRepositoryProtocol
    ) {
      self.repository = repository
    }

    func selectVoiceItem(_ voiceItem: VoiceItemIdentifiable) {
      voiceItems = voiceItems.map {
        return VoiceItemIdentifiable(
          id: $0.id,
          name: $0.name,
          iconUri: $0.iconUri,
          isActive: $0.id == voiceItem.id
        )
      }
      self.voiceSampleId = Int.random(in: 1..<20)
      Task {
        let fileUri = try? await self.repository.fetchVoiceFile(
          voiceId: voiceItem.id, voiceSampleId: self.voiceSampleId)
        playAudio(fileUri)
      }
    }

    private func playAudio(_ fileUri: URL? = nil) {
      guard let fileUri = fileUri else {
        return
      }
      do {
        if player?.isPlaying ?? false {
          player?.stop()
        }
        player = try AVAudioPlayer(contentsOf: fileUri)
        player?.prepareToPlay()
        player?.play()
      } catch {
        // do nothing
      }
    }

    func getVoiceItems() {
      self.voiceItems = repository.getVoiceItems()
    }

    func stopAudio() {
      player?.stop()
    }
  }
}
