//
//  NumberFormatter+Utils.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/12/23.
//

import Foundation

extension NumberFormatter {
  static func formatOptionalYear(_ year: Int?) -> String {
    guard let year = year else {
      return "Unknown"
    }
    
    let formatter = NumberFormatter()
    
    formatter.numberStyle = .decimal
    formatter.usesGroupingSeparator = false
    
    return formatter.string(from: year as NSNumber) ?? "Unknown"
  }
}
