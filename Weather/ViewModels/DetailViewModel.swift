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
  
  var collectionViewsItems = Variable<[APIResponseForecastListValue]>([])
  
  func viewDidLoad() {
    openWeatherCommunication.getForecast(of: currentWeather.name!, in: currentWeather.systemInfos.country!)
      .subscribe(
        onNext: { [weak self] response in
          print(response.linesCount)
          guard let strongSelf = self else { return }
          if !strongSelf.collectionViewsItems.value.isEmpty {
            strongSelf.collectionViewsItems.value.removeAll()
          }
          strongSelf.collectionViewsItems.value.append(contentsOf: response.weatherList)
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
