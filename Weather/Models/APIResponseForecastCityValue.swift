//
//  APIResponseForecastCityValue.swift
//  Weather
//
//  Created by Odet Alexandre on 09/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import ObjectMapper

class APIResponseForecastCityValue: Mappable {
  var id: Int!
  var name: String!
  var coordinates: APIResponseCoordinatesValue!
  
  required init?(map: Map) {
  }
  
  func mapping(map: Map) {
    id <- map["id"]
    name <- map["name"]
    coordinates <- map["coord"]
  }
}
