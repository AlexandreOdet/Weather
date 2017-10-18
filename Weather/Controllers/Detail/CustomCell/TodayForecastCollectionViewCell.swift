//
//  TodayForecastCollectionViewCell.swift
//  Weather
//
//  Created by Odet Alexandre on 18/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class TodayForecastCollectionViewCell: UICollectionViewCell {
  
  var hourLabel = UILabel()
  var weatherIcon = UIImageView()
  var averageTempLabel = UILabel()
  
  init() {
    super.init(frame: CGRect.zero)
    setUpView()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUpView() {
    contentView.addSubview(hourLabel)
    hourLabel.snp.makeConstraints { (make) -> Void in
      make.leading.equalToSuperview().offset(10)
      make.top.equalToSuperview().offset(10)
      make.trailing.equalToSuperview().offset(-10)
    }
    hourLabel.textAlignment = .center
    
    contentView.addSubview(averageTempLabel)
    averageTempLabel.snp.makeConstraints { (make) -> Void in
      make.center.equalToSuperview()
    }
    averageTempLabel.textAlignment = .center
  }
}
