//
//  RestApiBase.swift
//  Weather
//
//  Created by Odet Alexandre on 27/09/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import Alamofire

class RestApiBase {
  var request: Alamofire.Request?
  
  let baseUrl = "https://api.openweathermap.org/data/2.5/"
  
  func cancelRequest() {
    request?.cancel()
  }
}
