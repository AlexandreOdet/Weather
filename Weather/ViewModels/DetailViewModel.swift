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
  
  var forecastPerDay = Variable<[ThreeHoursWeather]>([])
  
  init(weather: APIResponseWeather) {
    currentWeather = weather
  }
  
  func viewDidLoad() {
    openWeatherCommunication.getForecast(of: currentWeather.name!, in: currentWeather.systemInfos.country!)
      .subscribe(
        onNext: { [weak self] response in
          guard let strongSelf = self else { return }
          strongSelf.sortForecastResponseByDay(serverResponse: response)
          if !strongSelf.collectionViewsItems.value.isEmpty {
            strongSelf.collectionViewsItems.value.removeAll()
          }
          strongSelf.collectionViewsItems.value.append(contentsOf: response.weatherList)
      },
        onError: { _ in return
      }).disposed(by: disposeBag)
  }
  
  func sortForecastResponseByDay(serverResponse: APIResponseForecast) {
    var currentDayOfTheWeek = -1
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = Constants.network.openWeatherApiForecastDateFormat
    let calendar = Calendar.current
    serverResponse.weatherList.forEach { item -> Void in
      guard let currentDate = dateFormatter.date(from: item.date) else { return }
      let forecast = ThreeHoursWeather(day: -1, weathers: [])
      let day = calendar.component(.weekday, from: currentDate)
      if day != currentDayOfTheWeek {
        forecastPerDay.value.append(forecast)
        currentDayOfTheWeek = day
        forecast.dayOfTheWeek = currentDayOfTheWeek
      }
      forecast.weathers.append(item)
    }
    forecastPerDay.value.forEach {
      print(WeekDay(dayOfTheWeek: $0.dayOfTheWeek).printableValue,
            " -> minimale: ",
            Converter.convertKelvinToCelsius(kelvin: $0.minimalTemp),
            " maximale: ",
            Converter.convertKelvinToCelsius(kelvin: $0.maximalTemp))
    }
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
