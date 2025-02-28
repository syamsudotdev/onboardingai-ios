//
//  VoiceSwitcherTypes.swift
//  OnboardingAI iOS
//
//  Created by nrsys on 28/02/25.
//

struct VoiceItemIdentifiable : Identifiable {
    let id: Int
    let name: String
    let iconUri: String
    let isActive: Bool
}
