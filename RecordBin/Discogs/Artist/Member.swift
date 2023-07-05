//
//  Member.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/9/23.
//

import Foundation

struct Member: Decodable, Identifiable, Equatable, Hashable {
  let id: Int
  let name: String
  let resourceURL: String
  let active: Bool
  let thumbnailURL: String?
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case resourceURL = "resource_url"
    case active
    case thumbnailURL = "thumbnail_url"
  }
}
