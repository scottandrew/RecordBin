//
//  ContentView.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/4/23.
//

import SwiftUI

struct ContentView: View {
  @StateObject var searchViewModel = SearchViewModel()
  @State var searchString: String = ""
  @State private var presntedItems: [SearchResult] = []
  
  
  var body: some View {
    NavigationStack(path: $presntedItems) {
      SearchResultView(searchResult: $searchString)
        .searchable(text: $searchString)
        .padding(0)
        .toolbar{
          Button(action: {}) {
            Label("Record Progress", systemImage: "book.circle")
          }
        }
    }
    .navigationDestination(for: SearchResult.self) { result in
      Text("for")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
    ContentView(searchString: "")
    }
}
