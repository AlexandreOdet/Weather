//
//  ThreeHoursWeather.swift
//  Weather
//
//  Created by Odet Alexandre on 10/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation

class ForecastPerDay {
  var dayOfTheWeek: Int = -1
  var weathers: [APIResponseForecastListValue] = []
  
  init(day: Int, weathers: [APIResponseForecastListValue]) {
    dayOfTheWeek = day
    self.weathers.removeAll()
    self.weathers.append(contentsOf: weathers)
  }  
}
