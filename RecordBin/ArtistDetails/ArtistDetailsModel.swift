//
//  ArtistDetailsModel.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/9/23.
//

import Foundation

@MainActor
class ArtistDetailsModel: ObservableObject {
  @Published var artist: Artist?
  
  var currentMembers: [Member]{
    return artist?.members?.filter{ $0.active } ?? []
  }
  
  var pastMembers: [Member] {
    return artist?.members?.filter { !$0.active } ?? []
  }
    
  var imageURL: URL? {
    if let address = artist?.images[0].url {
      return URL(string: address)!
    }
    
    return nil
  }
  
  init() {
  }
  
  init (url: String) {
    Task {
      do {
        artist = try await Discogs.shared.artist(url: url)
      } catch {
        debugPrint(error)
      }
    }
  }
}

class PreviewArtistDetailsModel: ArtistDetailsModel {
  override init(url: String) {
    // we don't want to load so init through default.
    super.init()
    
    // lets simplify by using a data loader.
    Task {
      do {
        let data = try Data(contentsOf: URL(string: url)!)
        artist = try JSONDecoder().decode(Artist.self, from: data)

      } catch {
        debugPrint(error)
      }
    }
  }
}
