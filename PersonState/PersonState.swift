//
//  PersonState.swift
//  PersonState
//
//  Created by Foggin, Oliver (Developer) on 07/09/2021.
//

import Foundation
import UIKit
import ComposableArchitecture
import Common

public struct PersonState: Equatable, Identifiable, Changeable {
  public enum Subtitle {
    case age
    case birthday
  }
  
  public var person: Person
  
  public var id: UUID { person.id }
  public var isEditSheetPresented = false
  public var subtitle: Subtitle = .age
  public var isEditingGiftName = false
  public var now: () -> Date
  public var calendar: Calendar
  
  public init(person: Person, now: @escaping () -> Date, calendar: Calendar) {
    self.person = person
    self.now = now
    self.calendar = calendar
  }
  
  public static func == (lhs: PersonState, rhs: PersonState) -> Bool {
    return lhs.person == rhs.person
  }
}

public enum PersonAction {
  case detailAction(PersonState.DetailAction)
  case editAction(PersonState.EditAction)
}

public struct PersonEnvironment {
  public init(main: AnySchedulerOf<DispatchQueue>, uuid: @escaping () -> UUID) {
    self.main = main
    self.uuid = uuid
  }
  
  public let main: AnySchedulerOf<DispatchQueue>
  public let uuid: () -> UUID
}

public let personReducer = Reducer.combine(
  personDetailReducer.pullback(
    state: \.detailState,
    action: /PersonAction.detailAction,
    environment: { env in PersonEnvironment(main: env.main, uuid: env.uuid) }
  ),
  personEditReducer.pullback(
    state: \.editState,
    action: /PersonAction.editAction,
    environment: { env in PersonEnvironment(main: env.main, uuid: env.uuid) }
  ),
  Reducer<PersonState, PersonAction, PersonEnvironment> {
    state, action, environment in
    
    switch action {
    case .detailAction:
      return .none
    case .editAction:
      return .none
    }
  }
)
  .debug()
