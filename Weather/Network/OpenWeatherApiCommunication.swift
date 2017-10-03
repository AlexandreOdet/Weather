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
  
  func getWeather(from city: String, country: String) -> Observable<APIResponseWeather> {
    let finalUrl = baseUrl + "weather?"
    parameters["q"] = city + ", " + country
    return Observable.create({ observer in
      self.request = Alamofire.request(finalUrl).responseObject(completionHandler: {
        (response: DataResponse<APIResponseWeather>) in
        switch response.result {
        case .success(let data):
          observer.onNext(data)
          observer.onCompleted()
        case .failure(let error):
          observer.onError(error)
        }
      })
      return Disposables.create()
    })
  }
}
