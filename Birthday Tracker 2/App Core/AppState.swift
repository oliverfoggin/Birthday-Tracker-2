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
  
  var newPersonState: NewPersonState?
  @BindableState var isNewPersonSheetPresented = false
}

enum AppAction: BindableAction {
  case personAction(id: Person.ID, action: PersonAction)
  case addPersonButtonTapped
  case newPersonAction(NewPersonAction)
  case binding(BindingAction<AppState>)
}

struct AppEnvironment {
  var uuid: () -> UUID
  var now: () -> Date
}

extension AppEnvironment {
  static var live: Self = Self.init(
    uuid: UUID.init,
    now: Date.init
  )
}

let appReducer = Reducer.combine(
  personReducer.forEach(
    state: \.sortedPeople,
    action: /AppAction.personAction(id:action:),
    environment: { _ in PersonEnvironment() }
  ),
  newPersonReducer
    .optional().pullback(
      state: \.newPersonState,
      action: /AppAction.newPersonAction,
      environment: { _ in NewPersonEnvironment() }
    ),
  Reducer<AppState, AppAction, AppEnvironment> {
    state, action, environment in
    switch action {
    case .personAction:
      return .none
    case .addPersonButtonTapped:
      state.newPersonState = NewPersonState(dob: environment.now())
      state.isNewPersonSheetPresented = true
      return .none
    case .newPersonAction(.saveButtonTapped):
      guard let newPerson = state.newPersonState else {
        return .none
      }
      
      state.sortedPeople.append(
        PersonState(
          person: Person(
            id: environment.uuid(),
            name: newPerson.name,
            dob: newPerson.dob
          )
        )
      )
      
      state.newPersonState = nil
      state.isNewPersonSheetPresented = false
      
      return .none
    case .newPersonAction:
      return .none
    case .binding(_):
      return .none
    }
  }
)
  .debug()
