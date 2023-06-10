//
//  ArtistDetails.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/8/23.
//

import SwiftUI
import NukeUI
import WrappingHStack

struct ArtistDetails: View {
  @StateObject var model: ArtistDetailsModel
  
  init (url: String) {
    _model = ProcessInfo.processInfo.isSwiftUIPreview ?  StateObject(wrappedValue: PreviewArtistDetailsModel(url: url)) :
    StateObject(wrappedValue: ArtistDetailsModel(url: url))
  }
  
  var body: some View {
    ScrollView {
      VStack {
        LazyImage(url: model.imageURL) { state in
          
          if let image = state.image {
            image.resizable().scaledToFit()        .cornerRadius(15)
          }
        }
        .frame(maxHeight: 300, alignment: .top)

        Text(model.artist?.name ?? "").font(.largeTitle.bold())
      }
      .padding()
      
      Grid(alignment: .topLeading, horizontalSpacing: 8, verticalSpacing: 16) {
        GridRow {
          Text("Profile:")
            .gridColumnAlignment(.trailing)
          Text(model.artist?.profile ?? "")
            .gridColumnAlignment(.leading)
        }
        
        if model.artist?.members != nil {
          let currentMembers = model.currentMembers
          let pastMembers = model.pastMembers
          
          if (currentMembers.count > 0) {
            GridRow {
              Text("Members:")
                .gridColumnAlignment(.trailing)
              buildMemberGrid(members: currentMembers)
                .frame(maxWidth: .infinity)
            }
          }
          
          if (pastMembers.count > 0) {
            GridRow {
              Text("Past Members:")
                .gridColumnAlignment(.trailing)
              buildPasterMemberGrid(members: pastMembers)
                .frame(maxWidth: .infinity)
            }
          }
        }
      }
      .padding([.horizontal])
    }

    .background(ZStack{ Color(.controlBackgroundColor)
      LazyImage(url: model.imageURL) { state in
        
        if let image = state.image {
          
          image.resizable().scaledToFill().blur(radius: 80).opacity(0.35)
          
        }
        
      }})
  }
  
  @ViewBuilder func buildMemberGrid(members: [Member]) -> some View {
     
    WrappingHStack(members, lineSpacing: 8) { member in
      Button(action: {}) {Text(member.name)}.background(Color.blue.opacity(0.3)).buttonStyle(.bordered)
      }
    }
  
  @ViewBuilder func buildPasterMemberGrid(members: [Member]) -> some View {
    WrappingHStack(members, lineSpacing: 8) { member in
      Button(action: {}) {Text(member.name)}.background(Color.red.opacity(0.3)).buttonStyle(.bordered)
      }
  }
  
  // we will do this better later.
  @ViewBuilder func buildLinks(links: [String]) -> some View{
    WrappingHStack(links, lineSpacing: 8) { link in
      Button(action: {}) {Text(link)}.background(Color(.linkColor)).buttonStyle(.bordered)
      }
  }
}

struct ArtistDetails_Preview: PreviewProvider {
  static var previews: some View {
    ArtistDetails(url: Bundle.main.url(forResource: "The Beatles", withExtension: "json")!.absoluteString)
  }
}
