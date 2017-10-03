//
//  CityViewModel.swift
//  Weather
//
//  Created by Odet Alexandre on 27/09/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation

import RxSwift

class CityViewModel {
  
  var restApiWeather = OpenWeatherApiCommunication()
  
  var cityName = Variable<String>("")
  var countryName = Variable<String>("")
  var items = [APIResponseWeather]()
  
  var isValid : Observable<Bool>{
    return Observable.combineLatest(self.cityName.asObservable(), self.countryName.asObservable()) { !$0.isEmpty && !$1.isEmpty }
  }
  
  func fetchWeatherFromApi(city: String, country: String) {
    restApiWeather.getWeather(from: city, country: country).subscribe(
      onNext: { [weak self] data in
        guard let strongSelf = self else { return }
        if let index = strongSelf.items.index(where: { $0.name == data.name }) {
          strongSelf.items.remove(at: index)
          strongSelf.items.insert(data, at: index)
        }
      },
      onError: { error in
        return
    }).dispose()
  }
}
