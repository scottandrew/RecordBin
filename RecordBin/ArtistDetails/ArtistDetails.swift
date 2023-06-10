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
            image.resizable().scaledToFit().cornerRadius(15)
          }
        }
        .frame(maxHeight: 300, alignment: .top)
        Text(model.artist?.name ?? "").font(.largeTitle.bold()).padding()
        
        
        Grid(alignment: .topLeading, horizontalSpacing: 8, verticalSpacing: 16) {
          
          buildProfileRow()
          buildCurrentMembersGrid()
          buildPastMembersGrid()
        }
      }
      .padding( )
    }
    .background(ZStack{ Color(.controlBackgroundColor)
      LazyImage(url: model.imageURL) { state in
        if let image = state.image {
          image.resizable().scaledToFill().blur(radius: 80).opacity(0.35)
        }
        
      }})
  }
    
  @ViewBuilder func buildProfileRow() -> some View {
    if !(model.artist?.profile.isEmpty ?? true) {
      GridRow {
        Text("Profile:")
          .gridColumnAlignment(.trailing)
        HStack {
          Text(model.artist?.profile ?? "")
          Spacer()
        }
        .gridColumnAlignment(.leading)
      }
    }
  }
  
  @ViewBuilder func buildMemberGrid(members: [Member]) -> some View {
    GridRow {
      WrappingHStack(members, lineSpacing: 8) { member in
        LinkButton(link: URL(string: member.resourceURL)!,
                   title: member.name,
                   style: member.active ? .members : .pastMembers)
      }
    }
  }
  
  // sections..
  @ViewBuilder func buildCurrentMembersGrid() -> some View {
    let currentMembers = model.currentMembers
    
    if !currentMembers.isEmpty {
      GridRow{
        Text("Current Members:")
          .gridColumnAlignment(.trailing)
        buildMemberGrid(members: currentMembers)
      }
    }
  }
  
  @ViewBuilder func buildPastMembersGrid() -> some View {
    let pastMembers = model.pastMembers
    
    if !pastMembers.isEmpty {
      GridRow {
        Text("Past Members:")
          .gridColumnAlignment(.trailing)
        buildMemberGrid(members: pastMembers)
      }
    }
  }
}

struct ArtistDetails_Preview: PreviewProvider {
  static var previews: some View {
    ArtistDetails(url: Bundle.main.url(forResource: "The Beatles", withExtension: "json")!.absoluteString)
  }
}
