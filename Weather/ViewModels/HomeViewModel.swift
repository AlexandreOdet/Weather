//
//  CityViewModel.swift
//  Weather
//
//  Created by Odet Alexandre on 27/09/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import CoreLocation

import RxSwift

class HomeViewModel: NSObject {
  
  var restApiWeather = OpenWeatherApiCommunication()
  
  var cityName = Variable<String>("")
  var countryName = Variable<String>("")
  var items = Variable<[APIResponseWeather]>([])
  
  private var disposeBag = DisposeBag()
  private var locationManager = CLLocationManager()
  
  var isValid : Observable<Bool>{
    return Observable.combineLatest(self.cityName.asObservable(), self.countryName.asObservable()) { !$0.isEmpty && !$1.isEmpty }
  }
  
  func fetchWeatherFromApi(with city: String, in country: String) {
    restApiWeather.getWeather(from: city, in: country).subscribe(
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
  
  func fetchWeatherFromApi(with coordinates: [Double]) {
    restApiWeather.getWeather(from: coordinates).subscribe(
      onNext: { [weak self] data in
        guard let strongSelf = self else { return }
        if let index = strongSelf.items.value.index(where: { $0.name == data.name }) {
          strongSelf.items.value.remove(at: index)
          strongSelf.items.value.insert(data, at: index)
        } else {
          strongSelf.items.value.append(data)
        }
      },
      onError:{ _ in
        return
    }).disposed(by: disposeBag)
  }
  
  func viewDidLoad() {
    CityManager.fetchCitiesFromFile()
  }
  
  func didTapSaveButton() {
    CityManager.saveCitiesToFile()
  }
}

extension HomeViewModel: CLLocationManagerDelegate {
  func getUserLocation() {
    requestLocationAccess()
    if CLLocationManager.locationServicesEnabled() {
      locationManager.startUpdatingLocation()
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.delegate = self
    }
  }
  
  private func requestLocationAccess() {
    let status = CLLocationManager.authorizationStatus()
    
    switch status {
    case .authorizedAlways, .authorizedWhenInUse:
      return
    case .denied, .restricted:
      return
    default:
      locationManager.requestWhenInUseAuthorization()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let lastUserLocation = locations.last {
      let lat = lastUserLocation.coordinate.latitude
      let long = lastUserLocation.coordinate.longitude
      
      let coordinates = [lat, long]
      fetchWeatherFromApi(with: coordinates)
    }
    manager.stopUpdatingLocation()
  }
}
