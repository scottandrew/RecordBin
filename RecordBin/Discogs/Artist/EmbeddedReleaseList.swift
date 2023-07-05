//
//  EmbeddedReleaseList.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/12/23.
//

import SwiftUI
import NukeUI

struct EmbeddedArtistReleaseList: View {
  @StateObject var model: EmbeddedArtistReleaseListModel
  
  init (artist: Artist) {
    _model = StateObject(wrappedValue: EmbeddedArtistReleaseListModel(artist: artist))
  }
  
  var body: some View {
    LazyVStack {
      ForEach(model.items, id: \.id) { release in
        HStack {
          LazyImage(url: URL(string: release.thumbURL!)) { state in
            if let image = state.image {
              image.resizable().scaledToFit().cornerRadius(4)
            }
          }
          .frame(width: 48, height: 48, alignment: .leading)
          Text(release.title)
          Spacer()
          buildLabel(release: release)
            .frame(width: 150, alignment: .leading)
          Text(release.year ?? "Unknown")
        }
        .onAppear() {
          model.onItemAppear(release)
        }
      }
    }
  }
  
  @ViewBuilder
  func buildLabel(release: SearchResult) -> some View{
    if let label = release.label?.first {
      Text(label)
    } else {
      Text("")
    }
  }
}
