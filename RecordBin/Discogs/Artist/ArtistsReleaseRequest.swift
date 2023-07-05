//
//  ArtistReleaseRequest.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/11/23.
//

import Foundation

struct AristsReleasesRequest: Pagable {
  
  typealias Value = SearchResult
  
  enum SortOrder: String {
    case ascending = "asc"
    case descending = "desc"
  }
  
    enum Sort: String {
      case year
      case title
      case format
    }
  
  let order: SortOrder
  let sortField: Sort
  let artist: Artist
  let perPage: Int
  
  var api: String {
      return "artists/\(artist.id)/releases"
  }
  
  func loadPage(after currentPage: Pagination?, size: Int) async throws -> (items: [SearchResult], info: Pagination) {
    let nextPage = (currentPage?.page ?? 0) + 1;
    
    let response = try await Discogs.shared.artistRelease(artist: artist, order: order.rawValue, sortField: sortField.rawValue, page: nextPage, perPage: size)
    
    return (items: response.results, info: response.pagination)
  }
  
//  init(order: SortOrder, sortField: Sort, artist: Artist, page: Int = 1, perPage: Int = 100) {
//    self.order = order
//    self.sortField = sortField
//    self.artist = artist
//    self.page = page
//    self.perPage = perPage
//  }
}
