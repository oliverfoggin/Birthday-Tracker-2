//
//  NewState.swift
//  NewState
//
//  Created by Foggin, Oliver (Developer) on 07/09/2021.
//

import Foundation
import ComposableArchitecture

struct NewPersonState: Equatable {
  @BindableState var dob: Date
  @BindableState var name: String = ""
  
  var saveButtonDisabled: Bool {
    name.isEmpty
  }
}

enum NewPersonAction: BindableAction {
  case binding(BindingAction<NewPersonState>)
  case saveButtonTapped
  case cancelButtonTapped
}

struct NewPersonEnvironment {}

let newPersonReducer = Reducer<NewPersonState, NewPersonAction, NewPersonEnvironment> {
  state, action, environment in
  
  switch action {
  case .binding:
    return .none
  case .saveButtonTapped:
    return .none
  case .cancelButtonTapped:
    return .none
  }
}
.binding()
