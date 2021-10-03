import Foundation

public extension Sequence {
  func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>, using comparator: (T, T) -> Bool = (<)) -> [Element] {
    sorted(by: { a, b in
      return comparator(a[keyPath: keyPath], b[keyPath: keyPath])
    })
  }
}
