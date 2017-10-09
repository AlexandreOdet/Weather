//
//  OpenWeatherApiCommunication.swift
//  Weather
//
//  Created by Odet Alexandre on 27/09/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import RxSwift
import RxCocoa

class OpenWeatherApiCommunication: RestApiBase {
  
  func getWeather(from city: String, in country: String) -> Observable<APIResponseWeather> {
    let finalUrl = baseUrl + "weather?"
    parameters["q"] = city + ", " + country
    Utils.network.startSpinner()
    return Observable<APIResponseWeather>.create({ observer -> Disposable in
      self.request = Alamofire.request(finalUrl, parameters: self.parameters)
        .validate()
        .responseObject(completionHandler: { (response: DataResponse<APIResponseWeather>) in
          Utils.network.stopSpinner()
        switch response.result {
        case .success(let data):
          observer.onNext(data)
          observer.onCompleted()
        case .failure(let error):
          observer.onError(error)
        }
      })
      return Disposables.create(with: {
        self.request?.cancel()
      })
    })
  }
  
  func getWeather(from coordinates: [Double]) -> Observable<APIResponseWeather> {
     let finalUrl = baseUrl + "weather?"
    parameters["lat"] = String(coordinates[0])
    parameters["lon"] = String(coordinates[1])
    Utils.network.startSpinner()
    return Observable<APIResponseWeather>.create({ observer -> Disposable in
      self.request = Alamofire.request(finalUrl, parameters: self.parameters)
        .validate()
        .responseObject(completionHandler: { (response: DataResponse<APIResponseWeather>) in
          Utils.network.stopSpinner()
          switch response.result {
          case .success(let data):
            observer.onNext(data)
            observer.onCompleted()
          case .failure(let error):
            observer.onError(error)
          }
        })
      return Disposables.create(with: {
        self.request?.cancel()
      })
    })
  }
}

extension OpenWeatherApiCommunication {
  func getForecast(of city: String, in country: String) -> Observable<APIResponseForecast> {
    let finalUrl = baseUrl + "forecast?"
    parameters["q"] = city + ", " + country
    Utils.network.startSpinner()
    return Observable<APIResponseForecast>.create({ observer -> Disposable in
      self.request = Alamofire.request(finalUrl, parameters: self.parameters)
        .validate()
        .responseObject(completionHandler: { (response: DataResponse<APIResponseForecast>) in
          Utils.network.stopSpinner()
          switch response.result {
          case .success(let data):
            observer.onNext(data)
            observer.onCompleted()
          case .failure(let error):
            observer.onError(error)
          }
        })
      return Disposables.create(with: {
        self.request?.cancel()
      })
    })
  }
  
  func getForecast(of coordinates: [Double]) -> Observable<APIResponseForecast> {
    let finalUrl = baseUrl + "forecast?"
    parameters["lat"] = String(coordinates[0])
    parameters["lon"] = String(coordinates[1])
    Utils.network.startSpinner()
    return Observable<APIResponseForecast>.create({ observer -> Disposable in
      self.request = Alamofire.request(finalUrl, parameters: self.parameters)
        .validate()
        .responseObject(completionHandler: { (response: DataResponse<APIResponseForecast>) in
          Utils.network.stopSpinner()
          switch response.result {
          case .success(let data):
            observer.onNext(data)
            observer.onCompleted()
          case .failure(let error):
            observer.onError(error)
          }
        })
      return Disposables.create(with: {
        self.request?.cancel()
      })
    })
  }
}
