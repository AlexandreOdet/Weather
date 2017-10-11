//
//  ForecastViewModel.swift
//  Weather
//
//  Created by Odet Alexandre on 10/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import RxSwift

class ForecastViewModel {
  
  var forecastOfTheDay: ForecastPerDay!
  
  var itemsForTableView: Observable<[APIResponseForecastListValue]> {
    return Observable.just(forecastOfTheDay.weathers)
  }
  
  var isUserInteractionEnabledOnTableView: Observable<Bool> {
    return Observable.just(false)
  }
  
  init(forecast: ForecastPerDay) {
    forecastOfTheDay = forecast
  }
  
  func viewDidLoad() {
    
  }
}
