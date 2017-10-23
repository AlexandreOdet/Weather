//
//  City.swift
//  Weather
//
//  Created by Odet Alexandre on 18/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import ObjectMapper

class City: Mappable {
  var name: String!
  var latitude: Double!
  var longitude: Double!
  var country: String!
  
  init() {
    name = ""
    latitude = 0
    longitude = 0
    country = ""
  }
  
  required init?(map: Map) {
  }
  
  func mapping(map: Map) {
    name <- map["name"]
    latitude <- map["lat"]
    longitude <- map["lng"]
    country <- map["country"]
  }
}
