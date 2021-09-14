import Foundation
import ComposableArchitecture

public extension Array where Element: Identifiable {
  var identified: IdentifiedArrayOf<Element> {
    IdentifiedArray(uniqueElements: self)
  }
}
