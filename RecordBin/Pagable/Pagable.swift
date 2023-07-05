//
//  Pagable.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/12/23.
//

import Foundation

protocol Pagable {
  associatedtype Value: Identifiable & Hashable
  func loadPage(after currentPage: Pagination?, size: Int) async throws -> (items: [Value], info: Pagination)
}
