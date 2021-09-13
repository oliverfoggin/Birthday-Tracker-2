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
  var focusedField: Field?
  
  init(gift: Person.GiftIdea) {
    self.gift = gift
  }
}

enum GiftAction {
  case toggleFavourite
  case textFieldChanged(String)
  case toggleBought
  case setFocusedField(GiftState.Field?)
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
  
  case .setFocusedField:
    return .none
  }
}
