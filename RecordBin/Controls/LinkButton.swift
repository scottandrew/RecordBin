//
//  LinkButton.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/10/23.
//

import SwiftUI

struct LinkButton: View {
  enum Style {
    case members
    case pastMembers
    case link
  }
  
  let link: URL?
  let title: String
  let style: Style
  
  var body: some View {
    Button(title, action: {}).buttonStyle(LinkButtontyle(style: style))
  }
}
