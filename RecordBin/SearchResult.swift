//
//  Item.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/6/23.
//

import Foundation

struct UserData: Decodable {
  let isInWantList: Bool
  let isInCollcation: Bool

  enum CodingKeys: String, CodingKey {
    case isInWantList = "in_wantlist"
    case isInCollcation = "in_collection"
  }
}

struct SearchResult: Decodable, Equatable, Identifiable, Hashable {
  static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
    return lhs.id == rhs.id
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(itemId)
    hasher.combine(type)
    hasher.combine(masterId)
    hasher.combine(masterURL)
    hasher.combine(title)
    hasher.combine(uri)
    hasher.combine(thumbURL)
    hasher.combine(coverImageURL)
    hasher.combine(resourceURL)
  }

  enum ItemType: String, Decodable {
    case artist
    case master
    case release
    case label
  }

  let id = UUID()
  let itemId: Int
  let type: ItemType
  let userData: UserData
  let masterId: Int?
  let masterURL: String?
  let title: String
  let uri: String
  let thumbURL: String?
  let coverImageURL: String?
  let resourceURL: String?

  enum CodingKeys: String, CodingKey {
    case itemId = "id"
    case type
    case userData = "user_data"
    case masterId = "master_id"
    case masterURL = "master_url"
    case title
    case uri
    case thumbURL = "thumb"
    case coverImageURL = "cover_image"
    case resourceURL = "resource_url"
  }
}

typealias PagedSearchResults = PagedResponse<SearchResult>
