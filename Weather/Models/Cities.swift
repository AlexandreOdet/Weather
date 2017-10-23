//
//  Cities.swift
//  Weather
//
//  Created by Odet Alexandre on 18/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import ObjectMapper

final class Cities: Mappable {
  
  var cities: [City]!
  
  init() {
    cities = []
  }
  
  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    cities <- map["cities"]
  }
}
