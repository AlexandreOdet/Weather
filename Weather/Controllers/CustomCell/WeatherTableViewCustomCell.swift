//
//  WeatherTableViewCustomCell.swift
//  Weather
//
//  Created by Odet Alexandre on 03/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class WeatherTableViewCustomCell: UITableViewCell {
  
  var cityNameLabel = UILabel()
  var cityWeatherLabel = UILabel()
  
  init(reuseIdentifier: String) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
    setUpView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUpView() {
    contentView.addSubview(cityNameLabel)
    cityNameLabel.snp.makeConstraints { (make) -> Void in
      make.leading.equalToSuperview().offset(10)
      make.centerY.equalToSuperview()
    }
    
    contentView.addSubview(cityWeatherLabel)
    cityWeatherLabel.snp.makeConstraints { (make) -> Void in
      make.trailing.equalToSuperview().offset(-10)
      make.centerY.equalToSuperview()
    }
  }
}
