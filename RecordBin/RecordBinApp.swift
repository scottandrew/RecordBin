//
//  RecordBinApp.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/4/23.
//

import SwiftUI
import OAuthSwift

@main
struct RecordBinApp: App {
  @StateObject var appModel = ApplicationModel()
  
    var body: some Scene {
      WindowGroup {
        if appModel.isLogin {
          ContentView()
            .onAppear {
              appModel.authorize()
            }
            .onOpenURL { url in
              print("fucker")
              if url.host == "record-bin" {
                OAuthSwift.handle(url: url)
              }
            }
            .environmentObject(appModel)
        } else {
          LoginView()
            .onAppear {
              appModel.authorize()
            }
        }
      }
    }
}
