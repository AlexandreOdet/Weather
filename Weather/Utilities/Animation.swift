//
//  Animation.swift
//  Weather
//
//  Created by Odet Alexandre on 04/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import UIKit

final class Animation {
  public class func onClick(sender: UIView, backgroundColor: UIColor = .lightGray) {
    sender.backgroundColor = backgroundColor
    UIView.animate(withDuration: Constants.duration.onClickDuration) {
      sender.backgroundColor = .white
    }
  }
}
