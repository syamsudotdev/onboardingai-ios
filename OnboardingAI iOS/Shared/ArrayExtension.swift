//
//  ArrayExtension.swift
//  OnboardingAI iOS
//
//  Created by nrsys on 28/02/25.
//

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
