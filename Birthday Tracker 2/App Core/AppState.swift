//
//  AppState.swift
//  AppState
//
//  Created by Foggin, Oliver (Developer) on 07/09/2021.
//

import Foundation
import ComposableArchitecture

struct AppState: Equatable {
  var people: IdentifiedArrayOf<Person> = []
  
  var sortedPeople: IdentifiedArrayOf<PersonState> = []
}

enum AppAction {
  case personAction(id: Person.ID, action: PersonAction)
}

struct AppEnvironment {}

let appReducer = Reducer.combine(
  personReducer.forEach(
    state: \.sortedPeople,
    action: /AppAction.personAction(id:action:),
    environment: { _ in PersonEnvironment() }
  ),
  Reducer<AppState, AppAction, AppEnvironment> {
    state, action, environment in
    switch action {
    case .personAction:
      return .none
    }
  }
)
  .debug()
