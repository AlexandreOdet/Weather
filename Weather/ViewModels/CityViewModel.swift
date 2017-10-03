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
  var items = Variable<[APIResponseWeather]>([])
  
  fileprivate var disposeBag = DisposeBag()
  
  var isValid : Observable<Bool>{
    return Observable.combineLatest(self.cityName.asObservable(), self.countryName.asObservable()) { !$0.isEmpty && !$1.isEmpty }
  }
  
  func fetchWeatherFromApi(city: String, country: String) {
    restApiWeather.getWeather(from: city, country: country).subscribe(
      onNext: { [weak self] data in
        guard let strongSelf = self else { return }
        if let index = strongSelf.items.value.index(where: { $0.name == data.name }) {
          strongSelf.items.value.remove(at: index)
          strongSelf.items.value.insert(data, at: index)
        } else {
          strongSelf.items.value.append(data)
        }
      },
      onError: { error in
        return
    }).disposed(by: disposeBag)
  }
}
