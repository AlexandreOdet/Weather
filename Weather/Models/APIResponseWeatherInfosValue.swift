//
//  APIResponseWeatherInfosValue.swift
//  Weather
//
//  Created by Odet Alexandre on 02/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import ObjectMapper

class APIResponseWeatherInfosValue: Mappable {
  
  var temperature: Double!
  var pressure: Int!
  var humidity: Int!
  var minimalTemperature: Double!
  var maximalTemperature: Double!
  
  required init?(map: Map) {
  }
  
  func mapping(map: Map) {
    
  }
  
  /*
   "main": {
   "temp": 286.87,
   "pressure": 1012,
   "humidity": 72,
   "temp_min": 286.15,
   "temp_max": 288.15
   },
   */
}
