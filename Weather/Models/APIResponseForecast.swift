//
//  APIResponseForecast.swift
//  Weather
//
//  Created by Odet Alexandre on 04/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import ObjectMapper

class APIResponseForecast: Mappable {
  
  var statusCode: Int!
  var city: APIResponseForecastCityValue!
  var linesCount: Int!
  var messageTime: Float!
  var weatherList: [APIResponseForecastListValue]!
  
  required init?(map: Map) {
  }
  
  func mapping(map: Map) {
    statusCode <- map["cod"]
    messageTime <- map["message"]
    linesCount <- map["cnt"]
    weatherList <- map["list"]
    city <- map["city"]
  }
}




