//
//  NetworkUtilities.swift
//  Weather
//
//  Created by Odet Alexandre on 04/10/2017.
//  Copyright © 2017 Odet Alexandre. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

class Utils {
  class network {
    public class func startSpinner() {
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    public class func stopSpinner() {
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    public class var isNetworkAvailable: Bool {
      var zeroAddress = sockaddr_in()
      zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
      zeroAddress.sin_family = sa_family_t(AF_INET)
      
      let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
          SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
      }
      var flags = SCNetworkReachabilityFlags()
      if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        return false
      }
      let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
      let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
      return (isReachable && !needsConnection)
    }
  }
}
