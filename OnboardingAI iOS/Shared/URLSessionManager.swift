//
//  URLSessionManager.swift
//  OnboardingAI iOS
//
//  Created by nrsys on 01/03/25.
//

import Foundation

struct URLSessionManager {
  private static let BaseUri = "https://static.dailyfriend.ai/"
  private static let session: URLSession = {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 30
    configuration.timeoutIntervalForResource = 30
    return URLSession(configuration: configuration)
  }()
}

extension URLSessionManager {
  static func download(path: String) async throws -> (URL, URLResponse) {
    let url = URL(string: BaseUri + path)!
    let (urlResult, response) = try await self.session.download(from: url)
    return (urlResult, response)
  }

  static func get(path: String) async throws -> (Data, URLResponse) {
    let url = URL(string: BaseUri + path)!
    return try await self.session.data(from: url)
  }
}
