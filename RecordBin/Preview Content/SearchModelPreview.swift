//
//  SearchModelPreview.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/8/23.
//

import Foundation

class SearchModelPreview: SearchViewModel {
  
  override init() {
    super.init()
    
    do {
      let filePath = Bundle.main.url(forResource: "PreviewSearchResults", withExtension: "json")!
      let data = try Data(contentsOf: filePath)
      
      searchResults = try JSONDecoder().decode([SearchResult].self, from: data)
    } catch {}
  }
  
  override func next() { }
  override func search(query: String, page: Int = 1, perPage: Int = 100) {}
}
