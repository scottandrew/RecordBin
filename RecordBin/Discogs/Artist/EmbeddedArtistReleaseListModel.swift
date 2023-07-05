//
//  File.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/12/23.
//

import SwiftUI

@MainActor
class EmbeddedArtistReleaseListModel: PagingViewModel<AristsReleasesRequest> {
  // look at figurouting this out a bit more.. This should
  // be based on soemthing generic??
//  private (set) var currentPage = 0
//  private (set) var totalPages = 0
//  private (set) var isLoading = false
 // private let artist: Artist
  
  init(artist: Artist) {
//    self.artist = artist
    super.init(source: AristsReleasesRequest(order: .ascending, sortField: .year, artist: artist,  perPage: 100))
  }
  
//  @Published private (set) var releases = [ArtistsRelease]()
//  @Published private (set) var error: Error?
  
}


