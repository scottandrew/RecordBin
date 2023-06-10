//
//  ApplicationModel.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/4/23.
//

import Foundation

@MainActor
class ApplicationModel: ObservableObject {
  // we will hold on to our discogs.. We will pass around from here.
  //private let discogs = Discogs()
  private var identity: Identity?
 // @Published var state = Discogs.State.loggedOut
  
  var isLogin: Bool {
    return Discogs.shared.state == .loggedIn
  }
    
  func authorize() {
      Task.init {

        identity = try? await Discogs.shared.identity()
        
        await MainActor.run {
          objectWillChange.send()
        }
        
       // debugPrint(identity)
      }
  }
}
