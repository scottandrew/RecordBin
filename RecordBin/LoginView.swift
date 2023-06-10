//
//  LoginView.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/5/23.
//

import SwiftUI

struct LoginView: View {
  var body: some View {
    VStack {
      Button("Login to Discogs") {
        Task {
          await Discogs.shared.authorize()
          await try Discogs.shared.identity()
        }
      }
    }
  }
}
