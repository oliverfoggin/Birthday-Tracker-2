//
//  EditState.swift
//  EditState
//
//  Created by Foggin, Oliver (Developer) on 07/09/2021.
//

import Foundation
import ComposableArchitecture
import Common

public extension PersonState {
  struct EditState: Equatable {
    @BindableState var person: Person
  }
  
  enum EditAction: BindableAction {
    case binding(BindingAction<EditState>)
  }
  
  var editState: EditState {
    get { EditState(person: person) }
    set { person = newValue.person }
  }
}

public let personEditReducer = Reducer<PersonState.EditState, PersonState.EditAction, PersonEnvironment> {
  state, action, environment in
  
  switch action {
  case .binding:
    return .none
  }
}
  .binding()
