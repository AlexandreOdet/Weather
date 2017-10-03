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
  var weatherInfos: APIResponseWeatherInfosValue!
  var visibility: Int!
  var windInfo: APIResponseWindInfosValue?
  var cloudInfo: APIResponseCloudsInfoValue?
  var snowInfo: APIResponseSnowInfosValue?
  var rainInfo: APIResponseRainInfosValue?
  var dataCalculation: Double!
  var systemInfos: APIResponseSystemInfoValue!
  var id: Int!
  var name: String!
  var code: Int!
  
  required init?(map: Map) {
  }
  
  func mapping(map: Map) {
    coordinates <- map["coord"]
    weathers <- map["weather"]
    base <- map["base"]
    weatherInfos <- map["main"]
    visibility <- map["visibility"]
    windInfo <- map["wind"]
    cloudInfo <- map["clouds"]
    rainInfo <- map["rain"]
    snowInfo <- map["snow"]
    dataCalculation <- map["dt"]
    systemInfos <- map["sys"]
    id <- map["id"]
    name <- map["name"]
    code <- map["cod"]
  }
}
/*

 "id": 2643743,
 "name": "London",
 "cod": 200
 }
 */
