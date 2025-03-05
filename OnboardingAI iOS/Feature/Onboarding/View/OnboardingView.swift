//
//  OnboardingView.swift
//  OnboardingAI iOS
//
//  Created by nrsys on 01/03/25.
//

import Lottie
import SwiftUI

struct OnboardingView: View {
  private let voiceId: Int
  private let voiceSampleId: Int
  @State private var viewModel: ViewModel

  init(voiceId: Int, voiceSampleId: Int) {
    self.voiceId = voiceId
    self.voiceSampleId = voiceSampleId
    self.viewModel = ViewModel(
      voiceId: voiceId, voiceSampleId: voiceSampleId, onboardingRepository: OnboardingRepository())
  }

  var body: some View {
    VStack {
      LottieView {
        await LottieAnimation.loadedFrom(
          url: URL(string: "https://static.dailyfriend.ai/images/mascot-animation.json")!)
      }
      .playbackMode(.playing(.fromProgress(0, toProgress: 1, loopMode: .repeat(.infinity))))
      .frame(height: 190, alignment: .top)
      Spacer().frame(height: 16)
      Text(viewModel.transcription ?? "").font(.title).multilineTextAlignment(.center).fontWeight(
        .semibold
      ).padding(.horizontal, 16)
        .frame(height: viewModel.transcription == nil ? 0 : nil, alignment: .center).clipped()
      VStack {
        Button(action: {}) {
          Text("Login").font(.title3).fontWeight(.semibold)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
        .background(.orange).cornerRadius(25).foregroundColor(.white)
        Spacer().frame(height: 16)
        Button(action: {}) {
          Text("Register").font(.title3).fontWeight(.semibold)
            .foregroundStyle(.orange)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .overlay(RoundedRectangle(cornerRadius: 25).stroke(.orange, lineWidth: 2))
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 46)
        Spacer().frame(height: 16)
      }.frame(
        minWidth: 0, maxWidth: .infinity, minHeight: 0,
        maxHeight: viewModel.transcription == nil ? 0 : .infinity, alignment: .bottom
      )
      .padding(.horizontal, 16)
      .clipped()
    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
      .onAppear {
        viewModel.playAudio()
        viewModel.getTranscription()
        viewModel.verifyUser()
      }.onDisappear {
        viewModel.stopAudio()
      }
  }
}
