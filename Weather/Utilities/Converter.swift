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
    return kelvin - Constants.metrics.kelvinConverterValue
  }
  
  public class func convertKelvinToFahrenheit(kelvin: Double) -> Double {
    return kelvin * (9/5) - 459.67
  }
  
  public class func convertMeterPerSecondToKilometerPerHour(speed: Double) -> Double {
    return speed * Constants.metrics.kilometerPerHourConverterValue
  }
  
  public class func convertMeterSecondToMilesHour(speed: Double) -> Double {
    return speed * Constants.metrics.milesPerHourConverterValue
  }
  
  public class func convertAngleDegreesToCardinalDirection(degree: Double) -> CardinalDirection {
    let calculatedValue = Int((degree / 22.5) + 0.5)
    let directions = CardinalDirection.getCardinalDirectionsArray()
    return directions[calculatedValue % 16]
  }
}
