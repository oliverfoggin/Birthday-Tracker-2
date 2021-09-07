//
//  Array.swift
//  Array
//
//  Created by Foggin, Oliver (Developer) on 07/09/2021.
//

import Foundation
import ComposableArchitecture

extension Array where Element: Identifiable {
  var identified: IdentifiedArrayOf<Element> {
    IdentifiedArray(uniqueElements: self)
  }
}
