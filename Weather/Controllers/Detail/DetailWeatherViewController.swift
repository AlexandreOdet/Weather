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

class DetailWeatherViewController: UIViewController {
  
  private let disposeBag = DisposeBag()
  
  var viewModel: DetailViewModel!
  
  @IBOutlet weak var cityNameLabel: UILabel!
  @IBOutlet weak var cityTemperatureLabel: UILabel!
  @IBOutlet weak var weatherSegmentedControl: UISegmentedControl!
  @IBOutlet weak var sunriseLabel: UILabel!
  @IBOutlet weak var sunsetLabel: UILabel!
  
  private var temperatureIndex: Observable<Int> {
    return weatherSegmentedControl
      .rx
      .selectedSegmentIndex
      .asObservable()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpBinding()
    print(Converter.convertAngleDegreesToCardinalDirection(degree: (viewModel.currentWeather.windInfo?.degree!)!).abreviation)
    print("Sunrise -> ", Date(timeIntervalSince1970: viewModel.currentWeather.systemInfos.sunrise))
    print("Sunset -> ", Date(timeIntervalSince1970: viewModel.currentWeather.systemInfos.sunset))
  }
  
  private func setUpBinding() {
    cityNameLabel.text = viewModel.currentWeather.name
    
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
    
    viewModel.sunriseDateTimestamp.map { timestamp -> String in
      _ = timestamp
      return ""
    }.bind(to: sunriseLabel.rx.text)
    .disposed(by: disposeBag)
    
    viewModel.sunsetDateTimestamp.map { timestamp -> String in
      _ = timestamp
      return ""
    }.bind(to: sunsetLabel.rx.text)
    .disposed(by: disposeBag)
  }
}
