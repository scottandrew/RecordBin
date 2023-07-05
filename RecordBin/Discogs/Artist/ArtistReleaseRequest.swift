//
//  ArtistReleaseRequest.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/11/23.
//

import Foundation

struct AristsReleasesRequest {
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
  
  let page: Int
  let perPage: Int
  
  var api: String {
      return "artists/\(artist.id)/releases"
  }
  
  var arguments: [String: Any] {
    return [
      "sort": sortField.rawValue,
      "sort_order": order.rawValue,
      "page": page,
      "per_page": perPage
    ]
  }
  
  init(order: SortOrder, sortField: Sort, artist: Artist, page: Int = 1, perPage: Int = 100) {
    self.order = order
    self.sortField = sortField
    self.artist = artist
    self.page = page
    self.perPage = perPage
  }
}
