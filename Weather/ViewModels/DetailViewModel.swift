//
//  DetailViewModel.swift
//  Weather
//
//  Created by Odet Alexandre on 04/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

class DetailViewModel: NSObject {
  
  private let disposeBag = DisposeBag()
  
  var currentWeather: APIResponseWeather!
  var forecastWeather: APIResponseForecast!
  
  var openWeatherCommunication = OpenWeatherApiCommunication()
  
  var collectionViewsItems = Variable<[ForecastPerDay]>([])
  
  var hourInGivenCity: Observable<String> {
    let location = CLLocation(latitude: self.currentWeather.coordinates.latitude!,
                              longitude: self.currentWeather.coordinates.longitude!)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    dateFormatter.timeZone = location.timeZone
    let timestamp = Date().timeIntervalSince1970
    let date = Date(timeIntervalSince1970: timestamp)
    let formattedString = dateFormatter.string(from: date)
    return Observable.just(formattedString)
  }
  
  init(weather: APIResponseWeather) {
    currentWeather = weather
  }
  
  func viewDidLoad() {
    if Utils.network.isNetworkAvailable {
      openWeatherCommunication.getForecast(of: currentWeather.name!, in: currentWeather.systemInfos.country!)
        .subscribe(
          onNext: { [weak self] response in
            guard let strongSelf = self else { return }
            strongSelf.sortForecastResponseByDay(serverResponse: response)
          },
          onError: { _ in return
        }).disposed(by: disposeBag)
    }
  }
  
  func sortForecastResponseByDay(serverResponse: APIResponseForecast) {
    var currentDayOfTheWeek = -1
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = Constants.network.openWeatherApiForecastDateFormat
    let calendar = Calendar.current
    var weathers = [APIResponseForecastListValue]()
    
    serverResponse.weatherList.forEach { item -> Void in
      guard let currentDate = dateFormatter.date(from: item.date) else { return }
      let day = calendar.component(.weekday, from: currentDate)
      if day != currentDayOfTheWeek {
        let forecast = ForecastPerDay(day: day, weathers: weathers)
        collectionViewsItems.value.append(forecast)
        currentDayOfTheWeek = day
        weathers.removeAll()
        forecast.dayOfTheWeek = currentDayOfTheWeek
      }
      weathers.append(item)
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
