//
//  Constant.swift
//  Weather
//
//  Created by Odet Alexandre on 27/09/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import UIKit

final class Constants {
  
  final class network {
    
    public class var googleApiKey: String {
      return "AIzaSyBSmZs2SAcBjlKGEoaj8nmFtWmPyiO295E"
    }
    
    public class var openWeatherApiKey: String {
      return "2d59b6f6fd3b090e08101e1133911727"
    }
  }
  
  final class metrics {
    
    public class var kelvinConverterValue: Double {
      return 273.15
    }
    
    public class var kilometerHourConverterValue: Double {
      return 3.6
    }
  }
  
  final class database {
    
    public class var citiesFileName: String {
      return "cities.json"
    }
  }
  
  final class duration {
    public class var onClickDuration: Double {
      return 0.5
    }
  }
}
