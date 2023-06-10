//
//  ProcessInfo+Utils.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/8/23.
//

import Foundation

extension ProcessInfo {
  var isSwiftUIPreview: Bool {
      environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
  }
}
