//
//  APIResponseWeather.swift
//  Weather
//
//  Created by Odet Alexandre on 02/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import ObjectMapper

class APIResponseWeatherValue: Mappable {
  
  var id: Int!
  var weather: String!
  var description: String!
  var icon: String!
  
  required init?(map: Map) {
  }
  
  func mapping(map: Map) {
    id <- map["id"]
    weather <- map["main"]
    description <- map["description"]
    icon <- map["icon"]
  }
}
