//
//  OnboardingViewModel.swift
//  OnboardingAI iOS
//
//  Created by nrsys on 01/03/25.
//

import AVFoundation
import SwiftUI

extension OnboardingView {
    @MainActor
    @Observable
    final class ViewModel {
        private let voiceId: Int
        private let voiceSampleId: Int
        private(set) var transcription: String? = nil
        private let onboardingRepository: OnboardingRepositoryProtocol
        private var player: AVAudioPlayer? = nil

        init(voiceId: Int, voiceSampleId: Int, onboardingRepository: OnboardingRepositoryProtocol) {
            self.voiceId = voiceId
            self.voiceSampleId = voiceSampleId
            self.onboardingRepository = onboardingRepository
        }

        func playAudio() {
            guard let fileUri = onboardingRepository.getFileUri(voiceId, voiceSampleId) else {
                return
            }
            do {
                player = try AVAudioPlayer(contentsOf: fileUri)
                player?.prepareToPlay()
                player?.numberOfLoops = -1
                player?.play()
            } catch {
                print("Error playing file: \(fileUri.path())")
                print("Error playing file: \(error)")
            }
        }
        
        func getTranscription() {
            Task {
                transcription = await onboardingRepository.getTranscription(voiceId, voiceSampleId)
            }
        }
        
        func stopAudio() {
            player?.stop()
        }
    }
}
