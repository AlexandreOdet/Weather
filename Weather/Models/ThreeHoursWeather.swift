//
//  ThreeHoursWeather.swift
//  Weather
//
//  Created by Odet Alexandre on 10/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation

class ThreeHoursWeather {
  var dayOfTheWeek: Int = -1
  var weathers: [APIResponseForecastListValue] = []
  
  init(day: Int, weathers: [APIResponseForecastListValue]) {
    dayOfTheWeek = day
    self.weathers.removeAll()
    self.weathers.append(contentsOf: weathers)
  }
  
  var minimalTemp: Double {
    let minimalTempInArray = weathers.min(by: {
      return $0.weatherInfos.minimalTemperature < $1.weatherInfos.minimalTemperature
    })
    guard let min = minimalTempInArray else { return -1 }
    return min.weatherInfos.minimalTemperature
  }
 
  var maximalTemp: Double {
    let maximalTempInArray = weathers.max(by: {
      return $0.weatherInfos.maximalTemperature < $1.weatherInfos.maximalTemperature
    })
    guard let max = maximalTempInArray else { return -1 }
    return max.weatherInfos.maximalTemperature
  }
  
}
