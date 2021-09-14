import Foundation

public protocol Changeable {
  func with<T>(_ keyPath: WritableKeyPath<Self, T>, value: T) -> Self
}

public extension Changeable {
  func with<T>(_ keyPath: WritableKeyPath<Self, T>, value: T) -> Self {
    var clone = self
    clone[keyPath: keyPath] = value
    return clone
  }
}
