//
//  GiftState.swift
//  GiftState
//
//  Created by Foggin, Oliver (Developer) on 13/09/2021.
//

import Foundation
import ComposableArchitecture

struct GiftState: Equatable, Identifiable {
  enum Field: String, Hashable {
    case name
  }
  
  var gift: Person.GiftIdea
  var id: UUID { gift.id }
  @BindableState var focusedField: Field?
  
  init(gift: Person.GiftIdea) {
    self.gift = gift
  }
}

enum GiftAction: BindableAction {
  case toggleFavourite
  case textFieldChanged(String)
  case toggleBought
//  case setFocusedField(GiftState.Field?)
  case binding(BindingAction<GiftState>)
}

struct GiftEnvironment {}

let giftReducer = Reducer<GiftState, GiftAction, GiftEnvironment> {
  state, action, environment in
  
  switch action {
  case .toggleBought:
    state.gift.bought.toggle()
    return .none
    
  case .toggleFavourite:
    state.gift.favourite.toggle()
    return .none

  case let .textFieldChanged(name):
    state.gift.name = name
    return .none
  
  case .binding:
    return .none
  }
}
  .binding()
