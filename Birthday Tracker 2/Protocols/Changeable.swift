//
//  Changeable.swift
//  Changeable
//
//  Created by Foggin, Oliver (Developer) on 13/09/2021.
//

import Foundation

protocol Changeable {
  func with<T>(_ keyPath: WritableKeyPath<Self, T>, value: T) -> Self
}

extension Changeable {
  func with<T>(_ keyPath: WritableKeyPath<Self, T>, value: T) -> Self {
    var clone = self
    clone[keyPath: keyPath] = value
    return clone
  }
}
