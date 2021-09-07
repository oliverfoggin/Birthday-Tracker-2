//
//  PersonState.swift
//  PersonState
//
//  Created by Foggin, Oliver (Developer) on 07/09/2021.
//

import Foundation
import ComposableArchitecture
import UIKit

struct PersonState: Equatable, Identifiable {
  var person: Person
  
  var id: UUID { person.id }
  var isEditSheetPresented = false
}

enum PersonAction {
  case detailAction(PersonState.DetailAction)
  case editAction(PersonState.EditAction)
}

struct PersonEnvironment {}

let personReducer = Reducer.combine(
  personDetailReducer.pullback(
    state: \.detailState,
    action: /PersonAction.detailAction,
    environment: { _ in PersonEnvironment() }
  ),
  personEditReducer.pullback(
    state: \.editState,
    action: /PersonAction.editAction,
    environment: { _ in PersonEnvironment() }
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
