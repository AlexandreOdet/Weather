//
//  DetailViewModel.swift
//  Weather
//
//  Created by Odet Alexandre on 04/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import RxSwift

class DetailViewModel: NSObject {
  
  private let disposeBag = DisposeBag()
  
  var currentWeather: APIResponseWeather!
  var forecastWeather: APIResponseForecast!
  
  var openWeatherCommunication = OpenWeatherApiCommunication()
  
  func viewDidLoad() {
    openWeatherCommunication.getForecast(of: currentWeather.name!, in: currentWeather.systemInfos.country!)
      .subscribe(
        onNext: { response in
          print(response.linesCount)
      },
        onError: { _ in return
      }).disposed(by: disposeBag)
  }
  
  func cancelRequest() {
    openWeatherCommunication.cancelRequest()
  }
  
  var sunriseDateTimestamp: Observable<Double> {
    return Observable.just(currentWeather.systemInfos.sunrise)
  }
  
  var sunsetDateTimestamp: Observable<Double> {
    return Observable.just(currentWeather.systemInfos.sunset)
  }
  
  var visibilityValue: Observable<Int> {
    return Observable.just(currentWeather.visibility)
  }
  
  var humidityPercentageValue: Observable<Int> {
    return Observable.just(currentWeather.weatherInfos.humidity)
  }
}
