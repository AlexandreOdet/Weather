//
//  CityManager.swift
//  Weather
//
//  Created by Odet Alexandre on 04/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import ObjectMapper

class CityManager {
  
  public class func saveCitiesToFile(data: Cities) {
    let directory = NSTemporaryDirectory()
    let pathToFile = directory.appending(Constants.database.citiesFileName)
    print("path_to_file = \(pathToFile)")
    do {
      if let jsonString = data.toJSONString() {
        try jsonString.write(toFile: pathToFile, atomically: true, encoding: String.Encoding.utf8)
        print(" OK -----------> Everything goes well")
      } else {
        print(" KO ------------> Cannot create JSON String.")
      }
    }
    catch {
      print(" KO ------------> Something went wrong ->", error)
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
