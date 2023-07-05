//
//  PagedResponse.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/5/23.
//

import Foundation

struct URLs: Decodable {
  let first: String?
  let last: String?
  let next: String?
  let previous: String?
  
  enum CodingKeys: String, CodingKey {
    case first
    case last
    case next
    case previous = "prev"
  }
}

struct Pagination: Decodable,Equatable {
  static func == (lhs: Pagination, rhs: Pagination) -> Bool {
    return lhs.page == rhs.page
  }
  
  let perPage: Int
  let pageCount: Int
  let page: Int
  let itemCount: Int
  
  var hasNextPage: Bool { return page < pageCount }
  
  init(perPage: Int = 50) {
    self.perPage = perPage
    self.pageCount = 0
    self.page = 0
    self.itemCount = 0
  }
  
  enum CodingKeys: String, CodingKey {
    case perPage = "per_page"
    case pageCount = "pages"
    case page
    case itemCount = "items"
  }
}

protocol PagedResponse: Decodable {
  associatedtype T: Decodable
  
  var pagination: Pagination {get}
  var results: [T] {get}
}
