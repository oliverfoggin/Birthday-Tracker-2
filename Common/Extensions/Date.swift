import Foundation

public extension Date {
  func nextOccurence(from now: Date, using calendar: Calendar) -> Date {
    calendar.nextDate(
      after: self,
      matching: calendar.dateComponents([.day, .month], from: now),
      matchingPolicy: Calendar.MatchingPolicy.nextTimePreservingSmallerComponents,
      repeatedTimePolicy: Calendar.RepeatedTimePolicy.first,
      direction: Calendar.SearchDirection.forward
    )!
  }
}
