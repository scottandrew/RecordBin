//
//  IdentityResponse.swift
//  RecordBin
//
//  Created by Scott Andrew on 6/5/23.
//

import Foundation

struct Identity: Identifiable, Decodable {
  let id: Int
  let userName: String
  let resourceURL: String
  let consumerName: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case userName = "username"
    case resourceURL = "resource_url"
    case consumerName = "consumer_name"
  }
}
