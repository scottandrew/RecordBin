//
//  Discogs.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/4/23.
//

import SwiftUI
import OAuthSwift
import KeychainSwift

typealias PagedSearchResult = Result<PagedSearchResults, Error>
typealias PagedSearchCallback = (PagedSearchResult) -> Void

// we can observe the login state.. This can get called when we can't login.
class Discogs: ObservableObject {
  enum State {
    case loggedIn
    case loggedOut
    case loggingIn
  }
  
  enum DiscogsError : Error {
    case unknownError
  }
  
  private (set) var state = State.loggedOut
  private (set) var identity: Identity?
  
  // we need install a small callback to watch state.
  
  static var shared: Discogs = Discogs()
  
  // lets setup some our oauth stuff we need..
  private var oauth = OAuth1Swift(
    consumerKey: "rXFNTFSFMivCsiyPcUgY",
    consumerSecret: "BuWCrTFuVMyoHzpEyduZnvsQBeVslpzg",
    requestTokenUrl: "https://api.discogs.com/oauth/request_token",
    authorizeUrl: "https://www.discogs.com/oauth/authorize",
    accessTokenUrl: "https://api.discogs.com/oauth/access_token"
  )
    
  private let baseURL = URL(string: "https://api.discogs.com")!
  private let userAgent = "RecordBin/1.0"
  
  init() {
    let keychain = KeychainSwift()
    if let data = keychain.getData("auth"),
        let credentials = try? JSONDecoder().decode(OAuthSwiftCredential.self, from: data) {
      oauth.client.credential.oauthToken = credentials.oauthToken
      oauth.client.credential.oauthTokenSecret = credentials.oauthTokenSecret
    }
  }
  
  func needsLogin() -> Bool {
    return oauth.client.credential.isTokenExpired() || oauth.client.credential.oauthToken != ""
  }
  
  func get<T: Decodable> (api: String, parameters: [String: Any] = [:]) async throws -> T {
    return try await withCheckedThrowingContinuation { [weak self] continuation in
      guard let self = self else {
        return
      }

      // lets build our url.
      var url = api.hasPrefix(self.baseURL.absoluteString) ? URL(string: api)! : self.baseURL.appendingPathComponent(api)
      
      let headers = ["User-Agent": self.userAgent]
      
      self.oauth.client.get(url, parameters: parameters, headers: headers) { result in
        switch result {
        case .success(let response):
          do {
            let data = try JSONDecoder().decode(T.self, from: response.data)
            continuation.resume(returning: data)
          } catch {
            continuation.resume(throwing: error)
          }
          
        case.failure(let oauthError):
          DispatchQueue.main.async {
            self.state = .loggedOut
          }
          
          continuation.resume(throwing: oauthError)
        }
      }
    }
  }
  
  func search(query: String, page: Int, perPage: Int, callback: @escaping PagedSearchCallback ) -> OAuthSwiftRequestHandle? {
    let url = self.baseURL.appendingPathComponent("database/search")
    let headers = ["User-Agent": self.userAgent]
    
    // we are going to return the help
    return self.oauth.client.get(url, parameters: ["q": query, "page": page, "per_page": perPage], headers: headers) { result in
      var pagedSearchResult: PagedSearchResult
      switch result {
      case .success(let response):
        do {
          let pagedResult = try JSONDecoder().decode(PagedSearchResults.self, from: response.data)
          pagedSearchResult = PagedSearchResult.success(pagedResult)
        } catch {
          pagedSearchResult = PagedSearchResult.failure(error)
        }
      case .failure(let error): pagedSearchResult = PagedSearchResult.failure(error)
      }
      
      callback(pagedSearchResult)
    }
  }
  
  func artist(url: String) async throws -> Artist {
    let artist: Artist = try await get(api: url)
    
    return artist
  }
  
  func next(pagination: Pagination) async throws -> PagedSearchResults? {
    return try await withCheckedThrowingContinuation {continuation in
      guard let nextURL = pagination.urls.next?.encodedURL else {
        return continuation.resume(returning: nil)
      }
      
      let headers = ["User-Agent": self.userAgent]
      
      self.oauth.client.get(nextURL, headers: headers) { result in
        switch result {
        case .success(let results):
          do {
            let nextReults = try JSONDecoder().decode(PagedSearchResults.self, from: results.data)
            continuation.resume(returning: nextReults)
          } catch {
            continuation.resume(throwing: error)
          }
          
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
  
  @discardableResult
  func identity() async throws -> Identity? {
    self.identity = try await get(api: "oauth/identity")
    self.state = .loggedIn
    return identity
  }
  

  
  func authorize() async -> State {
    await MainActor.run {
      let controller = WebViewAuthController()

      oauth.authorizeURLHandler = controller
      
      NSApplication.shared.windows[0].contentViewController?.addChild(controller)
    }
    
    return await withCheckedContinuation{ [weak self] continuation in
      guard let self = self else {
        return
      }
      
     // oauth.authorizeURLHandler = OAuthWebViewController()
      oauth.authorize(withCallbackURL: "record-bin://authorize") { result in
        switch result {
        case .success( _):
          debugPrint("Discogs login: succeeded")
          
          let keychain = KeychainSwift()
          if let data = try? JSONEncoder().encode(self.oauth.client.credential) {
            keychain.set(data, forKey: "auth")
          }
          continuation.resume(returning: .loggedIn)
        case .failure(_):
          debugPrint("Discogs login: failed")
          continuation.resume(returning: .loggedOut)
        }
      }
    }
  }
}
