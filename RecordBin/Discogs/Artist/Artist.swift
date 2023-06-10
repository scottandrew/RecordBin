//
//  Artist.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/9/23.
//

import Foundation

struct Artist: Decodable, Hashable, Equatable, Identifiable {
  let id: Int
  let name: String
  let resourceURL: String
  let uri: String
  let releasesURL: String
  let images: [ImageResource]
  let profile: String
  let urls: [String]?
  let nameVariations: [String]?
  let aliases: [Alias]?
  let members: [Member]?
  let dataQuality: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case resourceURL = "resource_url"
    case uri
    case releasesURL = "releases_url"
    case images
    case profile
    case urls
    case nameVariations = "namevariations"
    case aliases
    case members
    case dataQuality = "data_quality"
  }
}
