//
//  APIResponseCloudsInfoValue.swift
//  Weather
//
//  Created by Odet Alexandre on 03/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import ObjectMapper

final class APIResponseCloudsInfoValue: Mappable {
  var percentage: Double!
  
  required init?(map: Map) {
  }
  
  func mapping(map: Map) {
    percentage <- map["all"]
  }
}
