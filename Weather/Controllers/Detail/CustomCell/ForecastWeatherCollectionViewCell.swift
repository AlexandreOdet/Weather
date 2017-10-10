//
//  ForecastWeatherCollectionViewCell.swift
//  Weather
//
//  Created by Odet Alexandre on 10/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ForecastWeatherCollectionViewCell: UICollectionViewCell {
  let label = UILabel()
  
  init() {
    super.init(frame: CGRect.zero)
    setUpContentView()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpContentView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setUpContentView() {
    contentView.addSubview(label)
    label.snp.makeConstraints { (make) -> Void in
      make.center.equalToSuperview()
      make.leading.equalToSuperview().offset(10)
      make.trailing.equalToSuperview().offset(-10)
    }
    label.textAlignment = .center
  }
}
