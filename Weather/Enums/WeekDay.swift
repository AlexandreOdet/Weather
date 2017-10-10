//
//  WeekDay.swift
//  Weather
//
//  Created by Odet Alexandre on 10/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation

enum WeekDay: Int {
  case sunday = 1
  case monday = 2
  case tuesday = 3
  case wednesday = 4
  case thursday = 5
  case friday = 6
  case saturday = 7
  
  case unknown = -1
  
  init(dayOfTheWeek: Int) {
    switch dayOfTheWeek {
    case 1:
      self = .sunday
    case 2:
      self = .monday
    case 3:
      self = .tuesday
    case 4:
      self = .wednesday
    case 5:
      self = .thursday
    case 6:
      self = .friday
    case 7:
      self = .saturday
    default:
      self = .unknown
    }
  }
  
  var printableValue: String {
    get {
      switch self {
      case .sunday:
        return "Dimanche"
      case .monday:
        return "Lundi"
      case .tuesday:
        return "Mardi"
      case .wednesday:
        return "Mercredi"
      case .thursday:
        return "Jeudi"
      case .friday:
        return "Vendredi"
      case .saturday:
        return "Samedi"
      default:
        return ""
      }
    }
  }
}
