//
//  DetailForecastTableViewCell.swift
//  Weather
//
//  Created by Odet Alexandre on 10/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class DetailForecastTableViewCell: UITableViewCell {
  
  var hourLabel = UILabel()
  var averageTempLabel = UILabel()
  var iconImg = UIImageView()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setUpView()
  }
  
  init(reuseIdentifier: String) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
    setUpView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUpView() {
    contentView.addSubview(hourLabel)
    contentView.addSubview(averageTempLabel)
    contentView.addSubview(iconImg)
    
    hourLabel.snp.makeConstraints { (make) -> Void in
      make.leading.equalToSuperview().offset(10)
      make.centerY.equalToSuperview()
      make.trailing.equalTo(averageTempLabel.snp.leading)
    }
    
    averageTempLabel.snp.makeConstraints { (make) -> Void in
      make.leading.equalTo(hourLabel.snp.trailing)
      make.center.equalToSuperview()
      make.trailing.equalTo(iconImg.snp.leading)
    }
    
    iconImg.snp.makeConstraints { (make) -> Void in
      make.leading.equalTo(averageTempLabel.snp.trailing)
      make.trailing.equalToSuperview()
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    iconImg.contentMode = .scaleAspectFit
  }
}
