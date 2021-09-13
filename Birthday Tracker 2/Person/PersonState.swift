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
  enum Subtitle {
    case age
    case birthday
  }
  
  var person: Person
  
  var id: UUID { person.id }
  var isEditSheetPresented = false
  var subtitle: Subtitle = .age
  var isEditingGiftName = false
  
  init(person: Person) {
    self.person = person
  }
  
  func with(subtitle: Subtitle) -> Self {
    var s = PersonState(person: person)
    
    s.isEditSheetPresented = isEditSheetPresented
    s.subtitle = subtitle
    
    return s
  }
}

enum PersonAction {
  case detailAction(PersonState.DetailAction)
  case editAction(PersonState.EditAction)
}

struct PersonEnvironment {
  let main: AnySchedulerOf<DispatchQueue>
}

let personReducer = Reducer.combine(
  personDetailReducer.pullback(
    state: \.detailState,
    action: /PersonAction.detailAction,
    environment: { env in PersonEnvironment(main: env.main) }
  ),
  personEditReducer.pullback(
    state: \.editState,
    action: /PersonAction.editAction,
    environment: { env in PersonEnvironment(main: env.main) }
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
