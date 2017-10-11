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
  
  private let collectionViewReuseIdentifier = "WeatherForecastCell"
  var viewModel: DetailViewModel!
  
  @IBOutlet weak var cityNameLabel: UILabel!
  @IBOutlet weak var cityTemperatureLabel: UILabel!
  @IBOutlet weak var weatherSegmentedControl: UISegmentedControl!
  @IBOutlet weak var sunriseLabel: UILabel!
  @IBOutlet weak var sunsetLabel: UILabel!
  @IBOutlet weak var minimalTemperatureLabel: UILabel!
  @IBOutlet weak var maximalTemperatureLabel: UILabel!
  
  @IBOutlet weak var sunriseIcon: UIImageView!
  @IBOutlet weak var minimalTemperatureIcon: UIImageView!
  
  var hourInCustomCity = UILabel()
  var currentWeatherInCity = UIImageView()
  
  var separatorTopView = UIView()
  var separatorBottomView = UIView()
  
  var visibilityValueLabel = UILabel()
  var humidityValueLabel = UILabel()
  var rainVolumeValueLabel = UILabel()
  var cloudinessValueLabel = UILabel()
  
  var collectionView: UICollectionView!
  
  deinit {
    viewModel.cancelRequest()
  }
  
  private var temperatureIndex: Observable<Int> {
    return weatherSegmentedControl
      .rx
      .selectedSegmentIndex
      .asObservable()
      .share()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.viewDidLoad()
    setUpInfosInTown()
    setUpSeparatorViews()
    setUpCurrentWeatherInfos()
    setUpCollectionView()
    setUpBinding()
  }
  
  private func setUpInfosInTown() {
    view.addSubview(hourInCustomCity)
    hourInCustomCity.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(cityNameLabel.snp.bottom).offset(10)
      make.leading.equalTo(cityNameLabel)
    }
    hourInCustomCity.font = hourInCustomCity.font.withSize(14)
    
    view.addSubview(currentWeatherInCity)
    currentWeatherInCity.snp.makeConstraints { (make) -> Void in
      make.centerY.equalTo(hourInCustomCity)
      make.trailing.equalTo(cityNameLabel)
      make.size.equalTo(30)
    }
    currentWeatherInCity.contentMode = .scaleAspectFit
    let urlString = "\(Constants.network.openWeatherApiIconsUrl)\(self.viewModel.currentWeather.weathers[0].icon!)\(Constants.network.openWeatherApiIconsFormat)"
    let url = URL(string: urlString)
    currentWeatherInCity.kf.setImage(with: url)
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
    let visibilityImg = UIImageView(image: UIImage(named: "visibility"))
    let humidityImg = UIImageView(image: UIImage(named: "humidity"))
    let rainImg = UIImageView(image: UIImage(named: "rain_icon"))
    let cloudImg = UIImageView(image: UIImage(named: "cloud_icon"))
    
    view.addSubview(visibilityImg)
    visibilityImg.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(separatorBottomView.snp.bottom).offset(10)
      make.size.equalTo(sunriseIcon)
      make.centerX.equalTo(sunriseIcon)
    }
    visibilityImg.contentMode = .scaleAspectFit
    
    view.addSubview(humidityImg)
    humidityImg.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(visibilityImg.snp.bottom).offset(10)
      make.size.equalTo(visibilityImg)
      make.centerX.equalTo(visibilityImg)
    }
    humidityImg.contentMode = .scaleAspectFit
    
    view.addSubview(rainImg)
    rainImg.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(visibilityImg)
      make.centerX.equalTo(minimalTemperatureIcon)
      make.size.equalTo(minimalTemperatureIcon)
    }
    rainImg.contentMode = .scaleAspectFit
    
    view.addSubview(rainVolumeValueLabel)
    rainVolumeValueLabel.snp.makeConstraints { (make) -> Void in
      make.trailing.equalToSuperview().offset(-10)
      make.centerY.equalTo(rainImg)
    }
    rainVolumeValueLabel.font = rainVolumeValueLabel.font.withSize(14)
    
    view.addSubview(cloudImg)
    cloudImg.snp.makeConstraints { (make) -> Void in
      make.top.equalTo(humidityImg)
      make.centerX.equalTo(rainImg)
      make.size.equalTo(rainImg)
    }
    cloudImg.contentMode = .scaleAspectFit
    
    view.addSubview(visibilityValueLabel)
    visibilityValueLabel.snp.makeConstraints { (make) -> Void in
      make.leading.equalTo(visibilityImg.snp.trailing).offset(5)
      make.centerY.equalTo(visibilityImg)
    }
    visibilityValueLabel.font = visibilityValueLabel.font.withSize(14)
    visibilityValueLabel.textAlignment = .center
    
    view.addSubview(humidityValueLabel)
    humidityValueLabel.snp.makeConstraints { (make) -> Void in
      make.leading.equalTo(humidityImg.snp.trailing).offset(5)
      make.centerY.equalTo(humidityImg)
    }
    humidityValueLabel.font = humidityValueLabel.font.withSize(14)
    humidityValueLabel.textAlignment = .center
  }
  
  private func setUpCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    layout.itemSize = CGSize(width: 100, height: 50)
    
    collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
    collectionView.register(ForecastWeatherCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewReuseIdentifier)
    collectionView.backgroundColor = .clear
    
    view.addSubview(collectionView)
    collectionView.snp.makeConstraints { (make) -> Void in
      make.bottom.equalToSuperview().offset(-10)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.height.equalTo(70)
    }
    
    viewModel.collectionViewsItems.asObservable()
      .bind(to: collectionView.rx.items(cellIdentifier: collectionViewReuseIdentifier, cellType: ForecastWeatherCollectionViewCell.self))
      { row, element, cell in
        cell.backgroundColor = .orange
        cell.label.text = "\(WeekDay(dayOfTheWeek: element.dayOfTheWeek).printableValue)"
        cell.label.adjustsFontSizeToFitWidth = true
    }
      .disposed(by: disposeBag)
    
    collectionView.rx.itemSelected
      .subscribe(onNext: { [weak self] indexPath in
        guard let strongSelf = self else { return }
        let forecastViewModel = ForecastViewModel(forecast: strongSelf.viewModel.collectionViewsItems.value[indexPath.row])
        let nextViewController = DetailForecastViewController(viewModel: forecastViewModel)
        strongSelf.navigationController?.pushViewController(nextViewController, animated: true)
      })
      .disposed(by: disposeBag)
  }
  
  private func setUpBinding() {
    cityNameLabel.text = "\(viewModel.currentWeather.name!)"
    
    viewModel.hourInGivenCity.bind(to: hourInCustomCity.rx.text).disposed(by: disposeBag)
    
    viewModel.humidityPercentageValue.map { value -> String in
      return "\(value)%"
    }
      .bind(to: humidityValueLabel.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.visibilityValue.map { value -> String in
      return "\(value / 1000) km"
    }
      .bind(to: visibilityValueLabel.rx.text)
      .disposed(by: disposeBag)
    
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
      }
      .bind(to: minimalTemperatureLabel.rx.text)
      .disposed(by: disposeBag)
    
    temperatureIndex.map { [unowned self] index -> String in
      let temperatureExtension = Temperature(intValue: index).printableMetrics
      let currentTemp = self.viewModel.currentWeather.weatherInfos.maximalTemperature!
      let convertedTemperature = (index == 0) ? Converter.convertKelvinToCelsius(kelvin: currentTemp) : Converter.convertKelvinToFahrenheit(kelvin: currentTemp)
      let nf = NumberFormatter()
      nf.numberStyle = .decimal
      nf.maximumFractionDigits = 1
      let temperatureString = nf.string(from: NSNumber(value: convertedTemperature)) ?? "--"
      return "\(String(describing: temperatureString))\(temperatureExtension)"
      }
      .bind(to: maximalTemperatureLabel.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.sunriseDate
      .bind(to: sunriseLabel.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.sunsetDate
      .bind(to: sunsetLabel.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.requestHasFailed.subscribe(onError: { [weak self] _ in
      guard let strongSelf = self else { return }
      let alert = UIAlertController(title: "Erreur", message: "Oups il semble y avoir un problème", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      alert.addAction(UIAlertAction(title: "Annuler", style: .destructive, handler: nil))
      strongSelf.present(alert, animated: true, completion: nil)
    }).disposed(by: disposeBag)
  }
}
