//
//  Temperature.swift
//  Weather
//
//  Created by Odet Alexandre on 04/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation

enum Temperature: Int {
  case celsius = 0
  case fahrenheit = 1
  case unknown = -1
  
  init(intValue: Int) {
    switch intValue {
    case 0:
      self = .celsius
    case 1:
      self = .fahrenheit
    default:
      self = .unknown
    }
  }
  
  var printableMetrics: String {
    switch self {
    case .celsius:
      return "°C"
    case .fahrenheit:
      return "°F"
    default:
      return ""
    }
  }
  
}
