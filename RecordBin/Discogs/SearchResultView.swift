//
//  SearchResultView.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/7/23.
//

import SwiftUI
import NukeUI

struct SearchResultView: View {
  @Binding var searchResult: String
  @StateObject var searchEngine = ProcessInfo.processInfo.isSwiftUIPreview ? SearchModelPreview() : SearchViewModel()
  @State var selected: SearchResult?
  
  var body: some View {
    ScrollView {
      LazyVStack{ ForEach(searchEngine.searchResults, id: \.id) { item in
        NavigationLink(value: item, label:  {SearchCell(item: item)})
            .onAppear {
              if item == searchEngine.searchResults.last {
                searchEngine.next()
              }
            }
            .buttonStyle(.plain)
        }
      }
      .onChange(of: searchResult) { newValue in
        searchEngine.search(query: newValue)
      }
      }
    .navigationDestination(for: SearchResult.self, destination: {item in ArtistDetails(url: item.resourceURL!)})
    }
   
  }
