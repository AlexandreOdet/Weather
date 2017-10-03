//
//  APIResponseSystemInfoValue.swift
//  Weather
//
//  Created by Odet Alexandre on 03/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import ObjectMapper

class APIResponseSystemInfoValue: Mappable {
  
  var type: Int!
  var id: Int!
  var message: Float!
  var country: String!
  var sunrise: Double!
  var sunset: Double!
  
  required init?(map: Map) {
  }
  
  func mapping(map: Map) {
    type <- map["type"]
    id <- map["id"]
    message <- map["message"]
    country <- map["country"]
    sunrise <- map["sunrise"]
    sunset <- map["sunset"]
  }
}
/*
 "sys": {
 "type": 1,
 "id": 5091,
 "message": 0.0057,
 "country": "GB",
 "sunrise": 1507010715,
 "sunset": 1507051953
 },
 */
