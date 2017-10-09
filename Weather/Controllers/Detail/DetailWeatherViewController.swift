//
//  DetailWeatherViewController.swift
//  Weather
//
//  Created by Odet Alexandre on 04/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import TimeZoneLocate
import CoreLocation

class DetailWeatherViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  
  var viewModel: DetailViewModel!
  
  @IBOutlet weak var cityNameLabel: UILabel!
  @IBOutlet weak var cityTemperatureLabel: UILabel!
  @IBOutlet weak var weatherSegmentedControl: UISegmentedControl!
  @IBOutlet weak var sunriseLabel: UILabel!
  @IBOutlet weak var sunsetLabel: UILabel!
  @IBOutlet weak var minimalTemperatureLabel: UILabel!
  @IBOutlet weak var maximalTemperatureLabel: UILabel!
  
  var separatorTopView = UIView()
  var separatorBottomView = UIView()
  
  
  private var temperatureIndex: Observable<Int> {
    return weatherSegmentedControl
      .rx
      .selectedSegmentIndex
      .asObservable()
      .share()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.backBarButtonItem?.title = ""
    setUpSeparatorViews()
    setUpBinding()
  }
  
  private func setUpSeparatorViews() {
    view.addSubview(separatorTopView)
    separatorTopView.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(sunriseLabel.snp.top).offset(-20)
      make.height.equalTo(1)
      make.width.equalToSuperview()
    }
    separatorTopView.backgroundColor = .lightGray
    
    view.addSubview(separatorBottomView)
    separatorBottomView.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(sunsetLabel.snp.bottom).offset(20)
      make.height.equalTo(1)
      make.width.equalToSuperview()
    }
    separatorBottomView.backgroundColor = .lightGray
  }
  
  private func setUpCurrentWeatherInfos() {
    
  }
  
  private func setUpBinding() {
    cityNameLabel.text = "\(viewModel.currentWeather.name!)"
    if let countryName = Utils.locale.getName(from: viewModel.currentWeather.systemInfos.country) {
      cityNameLabel.text?.append(", \(countryName)")
    }
    
    temperatureIndex
      .map { [unowned self] index -> String in
        let temperatureExtension = Temperature(intValue: index).printableMetrics
        let currentTemp = self.viewModel.currentWeather.weatherInfos.temperature!
        let convertedTemperature = (index == 0) ? Converter.convertKelvinToCelsius(kelvin: currentTemp) : Converter.convertKelvinToFahrenheit(kelvin: currentTemp)
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = 1
        let temperatureString = nf.string(from: NSNumber(value: convertedTemperature)) ?? "--"
        return "\(String(describing: temperatureString))\(temperatureExtension)"
      }
      .bind(to: cityTemperatureLabel.rx.text)
      .disposed(by: disposeBag)
    
    temperatureIndex.map { [unowned self] index -> String in
      let temperatureExtension = Temperature(intValue: index).printableMetrics
      let currentTemp = self.viewModel.currentWeather.weatherInfos.minimalTemperature!
      let convertedTemperature = (index == 0) ? Converter.convertKelvinToCelsius(kelvin: currentTemp) : Converter.convertKelvinToFahrenheit(kelvin: currentTemp)
      let nf = NumberFormatter()
      nf.numberStyle = .decimal
      nf.maximumFractionDigits = 1
      let temperatureString = nf.string(from: NSNumber(value: convertedTemperature)) ?? "--"
      return "\(String(describing: temperatureString))\(temperatureExtension)"
      }.bind(to: minimalTemperatureLabel.rx.text).disposed(by: disposeBag)
    
    temperatureIndex.map { [unowned self] index -> String in
      let temperatureExtension = Temperature(intValue: index).printableMetrics
      let currentTemp = self.viewModel.currentWeather.weatherInfos.maximalTemperature!
      let convertedTemperature = (index == 0) ? Converter.convertKelvinToCelsius(kelvin: currentTemp) : Converter.convertKelvinToFahrenheit(kelvin: currentTemp)
      let nf = NumberFormatter()
      nf.numberStyle = .decimal
      nf.maximumFractionDigits = 1
      let temperatureString = nf.string(from: NSNumber(value: convertedTemperature)) ?? "--"
      return "\(String(describing: temperatureString))\(temperatureExtension)"
      }.bind(to: maximalTemperatureLabel.rx.text).disposed(by: disposeBag)
    
    viewModel.sunriseDateTimestamp.map { [unowned self] timestamp -> String in
      let location = CLLocation(latitude: self.viewModel.currentWeather.coordinates.latitude!,
                                longitude: self.viewModel.currentWeather.coordinates.longitude!)
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "HH:mm"
      dateFormatter.timeZone = location.timeZone
      let date = Date(timeIntervalSince1970: timestamp)
      return dateFormatter.string(from: date)
      }.bind(to: sunriseLabel.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.sunsetDateTimestamp.map { [unowned self] timestamp -> String in
      let location = CLLocation(latitude: self.viewModel.currentWeather.coordinates.latitude!,
                                longitude: self.viewModel.currentWeather.coordinates.longitude!)
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "HH:mm"
      dateFormatter.timeZone = location.timeZone
      let date = Date(timeIntervalSince1970: timestamp)
      return dateFormatter.string(from: date)
      }.bind(to: sunsetLabel.rx.text)
      .disposed(by: disposeBag)
  }
}
