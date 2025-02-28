//
//  OnboardingView.swift
//  OnboardingAI iOS
//
//  Created by nrsys on 01/03/25.
//

import SwiftUI

struct OnboardingView: View {
    private let voiceId: Int
    private let voiceSampleId: Int
    @State private var viewModel: ViewModel

    init(voiceId: Int, voiceSampleId: Int) {
        self.voiceId = voiceId
        self.voiceSampleId = voiceSampleId
        self.viewModel = ViewModel(voiceId: voiceId, voiceSampleId: voiceSampleId, onboardingRepository: OnboardingRepository())
    }

    var body: some View {
        VStack {
            AsyncSVGImage(url: URL(string: "https://static.dailyfriend.ai/images/mascot.svg")) { image in
                image.resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }.frame(height: 190, alignment: .top)
            Spacer().frame(height: 16)
            if viewModel.transcription != nil {
                Text(viewModel.transcription!).font(.title).multilineTextAlignment(.center).frame(alignment: .center).fontWeight(.semibold).padding(.horizontal, 16)
                VStack {
                    Button(action: {}) {
                        Text("Login").font(.title).fontWeight(.semibold)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                    .background(.orange).cornerRadius(25).foregroundColor(.white)
                    Spacer().frame(height: 24)
                    Button(action: {}) {
                        Text("Register").font(.title).fontWeight(.semibold)
                            .foregroundStyle(.orange)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .overlay(RoundedRectangle(cornerRadius: 25).stroke(.orange, lineWidth: 2))
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                    Spacer().frame(height: 16)
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottom)
                    .padding(.horizontal, 16)
            }
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
            .onAppear {
                viewModel.playAudio()
                viewModel.getTranscription()
            }.onDisappear {
                viewModel.stopAudio()
            }
    }
}
