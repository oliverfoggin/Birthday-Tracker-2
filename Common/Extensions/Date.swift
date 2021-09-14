import Foundation

public extension Date {
  func nextOccurence(from now: Date, using calendar: Calendar) -> Date {
    calendar.nextDate(
      after: now,
      matching: calendar.dateComponents([.day, .month], from: self),
      matchingPolicy: .previousTimePreservingSmallerComponents,
      repeatedTimePolicy: .first,
      direction: .forward
    )!
  }
}
