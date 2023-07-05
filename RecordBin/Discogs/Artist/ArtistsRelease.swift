//
//  ArtistsRecord.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/10/23.
//

import Foundation

struct ArtistsRelease: Decodable, Identifiable, Equatable, Hashable {
  let id: Int
  let artist: String
  let mainRelease: Int?
  let resourceURL: String
  let thumbURL: String
  let title: String
  let type: String
  let year: Int?
  let format: String?
  let label: String?
  
  enum CodingKeys: String, CodingKey {
    case id
    case artist
    case mainRelease = "main_release"
    case resourceURL = "resource_url"
    case thumbURL = "thumb"
    case title
    case type
    case year
    case format
    case label
  }
}

class AsyncPagedSearchResponse: PagedResponse {
  typealias T = SearchResult
  
  var pagination: Pagination
  var results: [SearchResult]
  
  enum CodingKeys: String, CodingKey {
    case pagination
    case results = "results"
  }
  
}
