//
//  Alias.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/9/23.
//

import Foundation

struct Alias: Decodable, Equatable, Identifiable, Hashable {
  let id: Int
  let name: String
  let resourceURL: String
  let thumbnailURL: String?
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case resourceURL = "resource_url"
    case thumbnailURL = "thumbnail_url"
  }
}
