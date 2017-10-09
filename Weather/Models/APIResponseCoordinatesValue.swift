//
//  APIResponseCoordinates.swift
//  Weather
//
//  Created by Odet Alexandre on 02/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import ObjectMapper

class APIResponseCoordinatesValue: Mappable {
  
  var latitude: Double!
  var longitude: Double!
  
  required init?(map: Map) {
    
  }
  
  func mapping(map: Map) {
    latitude <- map["lat"]
    longitude <- map["lon"]
  }
  
  //"lon":139,"lat":35
}
