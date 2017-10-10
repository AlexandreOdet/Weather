//
//  APIResponseForecastListValue.swift
//  Weather
//
//  Created by Odet Alexandre on 04/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import ObjectMapper

class APIResponseForecastListValue: Mappable {
  
  var dataCalculation: Double!
  var weatherInfos: APIResponseWeatherInfosValue!
  var currentWeather: [APIResponseWeatherValue]!
  var windInfos: APIResponseWindInfosValue!
  var cloudInfos: APIResponseCloudsInfoValue!
  var date: String!
  
  required init?(map: Map) {
  }
  
  func mapping(map: Map) {
    dataCalculation <- map["dt"]
    weatherInfos <- map["main"]
    currentWeather <- map["weather"]
    cloudInfos <- map["clouds"]
    windInfos <- map["wind"]
    date <- map["dt_txt"]
  }
}
