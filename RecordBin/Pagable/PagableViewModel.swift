//
//  PagableViewModel.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/12/23.
//

import Foundation


class PagingViewModel<T: Pagable>: ObservableObject {
  @Published private (set) var items = [T.Value]()
  let source: T
  let pageSize: Int
  let threshold: Int
  private (set) var pageInfo: Pagination?
  
  enum PagingState: Equatable {
    static func == (lhs: PagingViewModel<T>.PagingState, rhs: PagingViewModel<T>.PagingState) -> Bool {
      switch (lhs, rhs) {
      case (.loadingFirstPage, .loadingFirstPage):
        return true
        
      case (.loaded, .loaded):
        return true
        
      case (.error, .error):
        return true
        
      default:
        return false
      }
    }
    
    case loadingFirstPage
    case loaded
    case loadingNextPage
    case error(error: Error)
  }

  
  private var currentTask: Task<Void, Never>? {
    willSet {
      if let task = currentTask {
        if task.isCancelled { return }
        
        task.cancel()
      }
    }
  }
  
  private var canLoadMorePages: Bool { pageInfo?.hasNextPage ?? true }
  private var state = PagingState.loaded
  
  init(source: T, threshold: Int = 25, pageSize: Int = 100) {
    self.source = source
    self.threshold = threshold
    self.pageSize = pageSize
    
    state = .loadingFirstPage
    currentTask = Task {
        await loadMoreItems()
    }
    
  }
  
  func onItemAppear(_ model: T.Value) {
    if !canLoadMorePages {
      return
    }
    
    if state == .loadingNextPage || state == .loadingFirstPage {
      return
    }
    
    guard let index = items.firstIndex(where: { $0.id == model.id }) else {
        return
    }
    
    // (4) appeared: Threshold not reached
    let thresholdIndex = items.index(items.endIndex, offsetBy: -threshold)
    if index != thresholdIndex {
        return
    }
    
    // (5) appeared: Load next page
    state = .loadingNextPage
    currentTask = Task {
        await loadMoreItems()
    }
    
  }
  
  func loadMoreItems() async {
    do {
      debugPrint("curren page \(pageInfo?.page ?? 0)")
      let response = try await source.loadPage(after: pageInfo, size: pageSize)
      
      if Task.isCancelled {
        return
      }
      
      let allItems = items + response.items
      
      await MainActor.run {
        self.items = allItems
        self.pageInfo = response.info
        
        state = .loaded
      }
    } catch {
      self.state = .error(error: error)
      debugPrint(error)
    }
  }
  
}

