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
  var currentWeather: APIResponseWeatherValue!
  var windInfos: APIResponseWindInfosValue!
  
  required init?(map: Map) {
  }
  
  func mapping(map: Map) {
  }
}

/*
 "list":[{
 "main":{
 "temp":298.77,
 "temp_min":298.77,
 "temp_max":298.774,
 "pressure":1005.93,
 "sea_level":1018.18,
 "grnd_level":1005.93,
 "humidity":87
 "temp_kf":0.26},
 "weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}],
 "clouds":{"all":88},
 "wind":{"speed":5.71,"deg":229.501},
 "sys":{"pod":"d"},
 "dt_txt":"2014-07-23 09:00:00"}
 ]}
 */
