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
  
  private var temperatureIndex: Observable<Int> {
    return weatherSegmentedControl
      .rx
      .selectedSegmentIndex
      .asObservable()
  }
  
  private var cityName: Observable<String> {
    return Observable.just(viewModel.currentWeather.name!)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpBinding()
    print(Converter.convertAngleDegreesToCardinalDirection(degree: (viewModel.currentWeather.windInfo?.degree!)!).abreviation)
  }
  
  private func setUpBinding() {
    cityName.bind(to: cityNameLabel.rx.text).disposed(by: disposeBag)
    
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
  }
}
