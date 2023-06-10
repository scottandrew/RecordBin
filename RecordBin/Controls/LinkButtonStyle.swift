//
//  ChipStyle.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/10/23.
//

import SwiftUI

struct LinkButtontyle: ButtonStyle {
  let style: LinkButton.Style
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .padding([.leading, .trailing], 8)
      .padding([.top, .bottom], 2)
      .background(ZStack{
        backgroundColor()
        configuration.isPressed ? Color.white.opacity(0.15) : Color.clear
      })
      .clipShape(RoundedRectangle(cornerRadius: 5))
  }
  
  func backgroundColor() -> Color {
    switch style {
    case .members: return Color("Members")
    case .pastMembers: return Color("Past Members")
    case .link: return Color("Link")
    }
  }
}


