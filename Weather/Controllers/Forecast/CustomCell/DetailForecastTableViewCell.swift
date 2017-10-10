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
  var iconImg = UIImageView()
  
  init(reuseIdentifier: String) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
    setUpView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUpView() {
    contentView.addSubview(hourLabel)
    hourLabel.snp.makeConstraints { (make) -> Void in
      make.leading.equalToSuperview().offset(10)
      make.centerY.equalToSuperview()
    }
  }
}
