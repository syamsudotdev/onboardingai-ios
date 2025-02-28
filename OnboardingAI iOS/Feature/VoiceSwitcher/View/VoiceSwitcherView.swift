//
//  VoiceSwitcherView.swift
//  OnboardingAI iOS
//
//  Created by nrsys on 27/02/25.
//

import SwiftUI

typealias VoiceItemDidTap = (VoiceItemIdentifiable) -> Void
typealias NextButtonDidTap = () -> Void

struct VoiceSwitcherView: View {
    @State private var viewModel = ViewModel(repository: VoiceSwitcherRepository())
    private var choosenVoiceItem: VoiceItemIdentifiable? {
        viewModel.voiceItems.first { $0.isActive }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Spacer().frame(height: 24)
                Text("Pick my voice").font(.title).frame(alignment: .top).fontWeight(.semibold)
                ScrollView {
                    AsyncSVGImage(url: URL(string: "https://static.dailyfriend.ai/images/mascot.svg")) { image in
                        image.resizable()
                            .renderingMode(.original)
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }.frame(height: 190)
                    Text("Find the voice that resonates with you").frame(alignment: .top)
                    VoiceItemView(voiceItems: viewModel.voiceItems, voiceItemDidTap: viewModel.selectVoiceItem)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
            LinkButton(choosenVoiceItem, voiceSampleId: viewModel.voiceSampleId)
        }.frame(alignment: .bottom)
            .onDisappear {
                viewModel.stopAudio()
            }
    }
}

struct VoiceItemView: View {
    private let voiceItems: [VoiceItemIdentifiable]
    private let voiceItemDidTap: VoiceItemDidTap
    
    init(voiceItems: [VoiceItemIdentifiable], voiceItemDidTap: @escaping VoiceItemDidTap) {
        self.voiceItems = voiceItems
        self.voiceItemDidTap = voiceItemDidTap
    }
    
    var body: some View {
        HStack {
            Spacer().frame(width: 16)
            Grid {
                let rows = self.voiceItems.chunked(into: 2)
                ForEach(0 ..< rows.count, id: \.self) { i in
                    let row = rows[i]
                    GridRow {
                        ForEach(row, id: \.id) { voiceItem in
                            VoiceCard(voiceItem, voiceItemDidTap)
                        }
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
                }
                GridRow {
                    Spacer().frame(height: 100)
                }
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
            Spacer().frame(width: 16)
        }
    }
}

struct VoiceCard: View {
    private let voiceItem: VoiceItemIdentifiable
    private let voiceItemDidTap: VoiceItemDidTap
    
    init(_ voiceItem: VoiceItemIdentifiable, _ voiceItemDidTap: @escaping VoiceItemDidTap) {
        self.voiceItem = voiceItem
        self.voiceItemDidTap = voiceItemDidTap
    }
    
    var body: some View {
        VStack {
            Spacer().frame(height: 8)
            HStack {
                Spacer().frame(width: 8)
                let title = voiceItem.name.capitalized
                Text(title).fontWeight(.semibold)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                Image(systemName: voiceItem.isActive ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(.orange)
                    .frame(width: 18, height: 18)
                Spacer().frame(width: 8)
            }.frame(alignment: .center)
            AsyncSVGImage(url: URL(string: voiceItem.iconUri)) { image in
                image.resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }.frame(minWidth: 0, maxWidth: .infinity, alignment: .bottom)
            Spacer().frame(height: 8)
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
            .background(voiceItem.id % 2 == 1 ? Color.pink.opacity(0.2) : Color.orange.opacity(0.2))
            .cornerRadius(10)
            .onTapGesture { voiceItemDidTap(voiceItem) }
    }
}

struct LinkButton: View {
    private let choosenVoiceItem: VoiceItemIdentifiable?
    private let voiceSampleId: Int
    private var voiceId: Int {
        choosenVoiceItem?.id ?? 0
    }
    
    init(_ choosenVoiceItem: VoiceItemIdentifiable?, voiceSampleId: Int) {
        self.choosenVoiceItem = choosenVoiceItem
        self.voiceSampleId = voiceSampleId
    }

    var body: some View {
        VStack {
            HStack {
                Spacer().frame(width: 16)
                if voiceId > 0 {
                    NavigationLink(destination: OnboardingView(voiceId: voiceId, voiceSampleId: voiceSampleId)) {
                        NextButton(isEnabled: true)
                    }
                } else {
                    NextButton(isEnabled: false)
                }
                Spacer().frame(width: 16)
            }.frame(alignment: .bottom)
            Spacer().frame(height: 16)
        }
    }
}

struct NextButton : View {
    private let isEnabled: Bool
    init(isEnabled: Bool) {
        self.isEnabled = isEnabled
    }
    private let enabledBackgroundColor = LinearGradient(gradient: Gradient(colors: [.orange, .yellow]), startPoint: .top, endPoint: .bottom)
    private let disabledBackgroundColor = LinearGradient(gradient: Gradient(colors: [.gray, .gray]), startPoint: .top, endPoint: .bottom)

    var body: some View {
        Button(action: {}) {
            Text("Next").font(.title)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50, alignment: .center)
        .background(isEnabled ? enabledBackgroundColor : disabledBackgroundColor)
        .cornerRadius(25)
        .foregroundColor(.white)
    }
}

#Preview {
    VoiceSwitcherView()
}
