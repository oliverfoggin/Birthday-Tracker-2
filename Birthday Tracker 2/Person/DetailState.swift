//
//  DetailState.swift
//  DetailState
//
//  Created by Foggin, Oliver (Developer) on 07/09/2021.
//

import Foundation
import ComposableArchitecture

extension PersonState {
  struct DetailState: Equatable {
    var person: Person
    @BindableState var isEditSheetPresented: Bool
  }
 
  enum DetailAction: BindableAction {
    case binding(BindingAction<DetailState>)
  }
  
  var detailState: DetailState {
    get {
      DetailState(
        person: person,
        isEditSheetPresented: isEditSheetPresented
      )
    }
    set {
      person = newValue.person
      isEditSheetPresented = newValue.isEditSheetPresented
    }
  }
}

let personDetailReducer = Reducer<PersonState.DetailState, PersonState.DetailAction, PersonEnvironment> {
  state, action, environment in
  
  switch action {
  case .binding:
    return .none
  }
}
  .binding()
