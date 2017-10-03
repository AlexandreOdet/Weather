//
//  Converter.swift
//  Weather
//
//  Created by Odet Alexandre on 02/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation

class Converter {
  public class func convertKelvinToCelsius(kelvin: Double) -> Double {
    return kelvin - Constants.kelvinConverterValue
  }
  
  public class func convertMeterSecondToKilometerHour(speed: Double) -> Double {
    return speed * Constants.kilometerHourConverterValue
  }
}
