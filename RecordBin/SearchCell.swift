//
//  SearchCell.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/7/23.
//

import SwiftUI
import NukeUI

struct SearchCell: View {
  @State var isHovering = false
  let item: SearchResult
  
  var body: some View {
    HStack{
      LazyImage(url: URL(string: item.thumbURL ?? "")) { state in
        
        if let image = state.image {
          image.resizable().aspectRatio(contentMode: .fit)
        }

      }
      .mask(generateMask())
      .frame(width: 48, height: 48)
      VStack(alignment: .leading, spacing: 0) {
        Text(item.title).font(.title3)
        Text(item.type.rawValue).font(.caption)
      }
    }
    .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
    .frame(
         minWidth: 0,
         maxWidth: .infinity,
         minHeight: 0,
         maxHeight: .infinity,
         alignment: .topLeading
       )
    .onHover { isHovering = $0 }
    .background(isHovering ? Color(NSColor.selectedTextBackgroundColor).opacity(0.25) : Color.clear)
  }
  
  @ViewBuilder
  func generateMask() -> some View {
    if item.type == .artist {
      Circle()
    } else {
      RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
    }
  }
}

struct SearchCell_Previews: PreviewProvider {
  // inject item..

    static var previews: some View {

      let item = SearchResult(itemId: 1, type: .artist, userData: UserData(isInWantList: false, isInCollcation: false), masterId: nil, masterURL: nil, title: "Pink Floyd", uri: "", thumbURL: Bundle.main.url(forResource: "pinkfloyd_thumb", withExtension: "jpeg")!.absoluteString, coverImageURL: nil, resourceURL: nil)
      
   SearchCell(item: item)
    }
}
