//
//  APIResponseWindInfosValue.swift
//  Weather
//
//  Created by Odet Alexandre on 03/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import ObjectMapper

final class APIResponseWindInfosValue: Mappable {
  var speed: Double!
  var degree: Double!
  
  required init?(map: Map) {
  }
  
  func mapping(map: Map) {
    speed <- map["speed"]
    degree <- map["deg"]
  }
}
