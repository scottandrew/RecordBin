//
//  ImageResource.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/9/23.
//

import Foundation

struct ImageResource: Decodable, Equatable, Hashable {
  enum ImageType: String, Decodable {
    case primary
    case secondary
  }
  
  let type: ImageType
  let url: String
  let resourceURL: String
  let thumbURL: String
  let width: Int
  let height: Int
  
  var size: CGSize {
    CGSize(width: width, height: height)
  }
  
  enum CodingKeys: String, CodingKey {
    case type
    case url = "uri"
    case resourceURL = "resource_url"
    case thumbURL = "uri150"
    case width
    case height
  }
}
