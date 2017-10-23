//
//  CityManager.swift
//  Weather
//
//  Created by Odet Alexandre on 04/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import ObjectMapper

final class CityManager {
  
  public class func saveCitiesToFile(data: Cities) {
    let directory = NSTemporaryDirectory()
    let pathToFile = directory.appending(Constants.database.citiesFileName)
    do {
      if let jsonString = data.toJSONString() {
        try? jsonString.write(toFile: pathToFile, atomically: true, encoding: String.Encoding.utf8)
      }
    }
  }
  
  public class func fetchCitiesFromFile() -> Cities? {
    let directory = NSTemporaryDirectory()
    let pathToFile = directory.appending(Constants.database.citiesFileName)
    
    if let jsonData = NSData(contentsOfFile: pathToFile) {
      if let jsonResult: NSDictionary = try! JSONSerialization
        .jsonObject(with: jsonData as Data,
                    options: .mutableContainers) as? NSDictionary {
        let mapper = Mapper<Cities>()
        if let cities = mapper.map(JSON: jsonResult as! [String : Any]) {
          return cities
        }
      }
    }
    return nil
  }
}
