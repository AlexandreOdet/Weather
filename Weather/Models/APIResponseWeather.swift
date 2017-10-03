//
//  APIResponseWeather.swift
//  Weather
//
//  Created by Odet Alexandre on 02/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import ObjectMapper

class APIResponseWeather: Mappable {
  var coordinates: APIResponseCoordinatesValue!
  var weathers: [APIResponseWeatherValue]!
  var base: String!
  
  required init?(map: Map) {
  }
  
  func mapping(map: Map) {
  }
}
