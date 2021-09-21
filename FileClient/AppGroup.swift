//
//  AppGroup.swift
//  AppGroup
//
//  Created by Foggin, Oliver (Developer) on 18/09/2021.
//

import Foundation

enum AppGroup: String {
  case birthdayTracker = "group.com.oliverfoggin.birthdaytracker"
  
  var containerURL: URL {
    switch self {
    case .birthdayTracker:
      return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: self.rawValue)!
    }
  }
}
