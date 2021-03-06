//
//  Person.swift
//  Person
//
//  Created by Foggin, Oliver (Developer) on 07/09/2021.
//

import Foundation
import IdentifiedCollections

public struct Person: Equatable, Identifiable, Codable {
  public var id: UUID
  public var name: String
  public var dob: Date
  public var giftIdeas: IdentifiedArrayOf<GiftIdea> = []
  
  public init(id: UUID, name: String, dob: Date) {
    self.id = id
    self.name = name
    self.dob = dob
  }
  
  public func nextBirthday(now: Date, calendar: Calendar) -> Date {
    dob.nextOccurence(from: now, using: calendar)
  }
}
