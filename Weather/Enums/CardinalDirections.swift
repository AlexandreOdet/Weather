//
//  CardinalDirections.swift
//  Weather
//
//  Created by Odet Alexandre on 04/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation

enum CardinalDirection {
  case north
  case south
  case east
  case west
  
  case northEast
  case northWest
  case southEast
  case southWest
  
  case northNorthEast
  case northNorthWest
  
  case eastNorthEast
  case eastSouthEst
  
  case southSouthEast
  case southSouthWest
  
  case westSouthWest
  case westNorthWest

  
  var abreviation: String {
    switch self {
    case .north:
      return "N"
    case .south:
      return "S"
    case .west:
      return "W"
    case .east:
      return "E"
    case .northEast:
      return "NE"
    case .northWest:
      return "NW"
    case .southEast:
      return "SE"
    case .southWest:
      return "SW"
    case .northNorthEast:
      return "NNE"
    case .northNorthWest:
      return "NNW"
    case .eastSouthEst:
      return "ESE"
    case .eastNorthEast:
      return "ENE"
    case .westNorthWest:
      return "WNW"
    case .westSouthWest:
      return "WSW"
    case .southSouthEast:
      return "SSE"
    case .southSouthWest:
      return "SSW"
    }
  }
  
  var printableValue: String {
    switch self {
    case .north:
      return "Nord"
    case .south:
      return "Sud"
    case .west:
      return "Ouest"
    case .east:
      return "Est"
    case .northEast:
      return "Nord-Est"
    case .northWest:
      return "Nord-Ouest"
    case .southEast:
      return "Sud-Est"
    case .southWest:
      return "Sud-Ouest"
    case .northNorthEast:
      return "Nord Nord-Est"
    case .northNorthWest:
      return "Nord Nord-Ouest"
    case .eastSouthEst:
      return "Est Sud-Est"
    case .eastNorthEast:
      return "Est Nord-Est"
    case .westNorthWest:
      return "Ouest Nord-Ouest"
    case .westSouthWest:
      return "Ouest Sud-Ouest"
    case .southSouthEast:
      return "Sud Sud-Est"
    case .southSouthWest:
      return "Sud Sud-Ouest"
    }
  }
  
  static func getCardinalDirectionsArray() -> [CardinalDirection] {
    return [.north, .northNorthEast, .northEast, .eastNorthEast,
            .east, .eastSouthEst, .southEast, .southSouthEast,
            .south, .southSouthWest, .southWest, .westSouthWest,
            .west, .westNorthWest, .northWest, .northNorthWest]
  }
}
