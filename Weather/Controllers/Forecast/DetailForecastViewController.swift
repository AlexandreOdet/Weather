//
//  DetailForecastViewController.swift
//  Weather
//
//  Created by Odet Alexandre on 10/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

final class DetailForecastViewController: UIViewController {
  var viewModel: ForecastViewModel!
  var tableView: UITableView!
  
  private let cellReuseIdentifier = "forecastCellIdentifier"
  private let disposeBag = DisposeBag()
  
  init(viewModel: ForecastViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: Bundle.main)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = WeekDay(dayOfTheWeek: viewModel.forecastOfTheDay.dayOfTheWeek).printableValue
    viewModel.viewDidLoad()
    setUpTableView()
  }
  
  private func calculateAverageTemp(minimalTemp: Double, maximalTemp: Double) -> Double {
    return ((minimalTemp + maximalTemp) / 2)
  }
  
  private func setUpTableView() {
    tableView = UITableView(frame: view.frame, style: .grouped)
    tableView.register(DetailForecastTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    viewModel.isUserInteractionEnabledOnTableView
      .bind(to: tableView.rx.isUserInteractionEnabled)
      .disposed(by: disposeBag)
    
    view.addSubview(tableView)
    tableView.snp.makeConstraints { (make) -> Void in
      make.edges.equalToSuperview()
    }
    viewModel.itemsForTableView
      .bind(to: tableView.rx.items(cellIdentifier: cellReuseIdentifier,
                                   cellType: DetailForecastTableViewCell.self)) {
                                    [unowned self] row, element, cell in
                                    let minimalTemp = self.viewModel.forecastOfTheDay.weathers[row].weatherInfos.minimalTemperature!
                                    let maximalTemp = self.viewModel.forecastOfTheDay.weathers[row].weatherInfos.maximalTemperature!
                                    let dateString = self.viewModel.forecastOfTheDay.weathers[row].date!
                                    let averageTemp = Converter.convertKelvinToCelsius(kelvin:  self.calculateAverageTemp(minimalTemp: minimalTemp, maximalTemp: maximalTemp))
                                    let nf = NumberFormatter()
                                    nf.numberStyle = .decimal
                                    nf.maximumFractionDigits = 1
                                    let temperatureString = nf.string(from: NSNumber(value: averageTemp))
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = Constants.network.openWeatherApiForecastDateFormat
                                    let date = dateFormatter.date(from: dateString)
                                    dateFormatter.dateFormat = "HH:mm"
                                    let dateFormattedString = dateFormatter.string(from: date!)
                                    
                                    cell.hourLabel.text = dateFormattedString
                                    
                                    cell.averageTempLabel.text = temperatureString! + Temperature.celsius.printableMetrics
                                    
                                    let urlString = "\(Constants.network.openWeatherApiIconsUrl)\(self.viewModel.forecastOfTheDay.weathers[row].currentWeather[0].icon!)\(Constants.network.openWeatherApiIconsFormat)"
                                    let url = URL(string: urlString)
                                    cell.iconImg.kf.setImage(with: url)
                                    
      }.disposed(by: disposeBag)
  }
}
