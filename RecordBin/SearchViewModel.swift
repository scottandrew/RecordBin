//
//  SearchView.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/4/23.
//

import Foundation
import OAuthSwift

class SearchViewModel: ObservableObject {
  enum State {
    case loading
    case loaded
  }
  
  private var state = State.loaded
  
  private var searchHandle: OAuthSwiftRequestHandle?
  private var lastQueryTime: TimeInterval = TimeInterval(0)
  private var lastPagination: Pagination?
  private var searchString: String = ""
  private var lastPage = 1
  private var totalPages = 0
  
  @Published var searchResults: [SearchResult] = []

  func next() {
    guard lastPage < totalPages, state != .loading else {
      return
    }
    
    state = .loading
  
    search(query: searchString, page: lastPage+1)
  }
  
  func resetSearch() {
    searchHandle?.cancel()
    searchHandle = nil
    state = .loaded
    searchResults = []
    lastQueryTime = 0
    lastPage = 1
  }
  
  func search(query: String, page: Int = 1, perPage: Int = 100) {
    
    if (query.isEmpty) {
      resetSearch()
      searchString = ""
      return 
    }
    
    let currentTime = Date().timeIntervalSince1970
    
    if (page == 1 && currentTime - lastQueryTime < 0.25 && page != lastPage) {
      return
    }
    
    if (page == 1 && query != searchString) {
      searchString = query
      resetSearch()
    }
    
    lastQueryTime = currentTime

      state = .loading
      
    searchHandle = Discogs.shared.search(query: query, page: page, perPage: perPage, callback: { [weak self] result in
       
        guard let self = self else { return }
        
        switch result {
        case .success(let results):
            // we need to grab out a few parameters.
          self.searchResults.append(contentsOf: results.results)
          lastPage = page
          totalPages = results.pagination.pageCount
          
        case .failure(let error):
          debugPrint(error)
        }
        
        state = .loaded
      })
    }
  }

