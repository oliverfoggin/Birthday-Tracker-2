//
//  GiftState.swift
//  GiftState
//
//  Created by Foggin, Oliver (Developer) on 13/09/2021.
//

import Foundation
import ComposableArchitecture

struct GiftState: Equatable, Identifiable {
  var gift: Person.GiftIdea
  var id: UUID { gift.id }
  
  init(gift: Person.GiftIdea) {
    self.gift = gift
  }
}

enum GiftAction {
  case startEditing
  case endEditing
  case toggleFavourite
  case textFieldChanged(String)
}

struct GiftEnvironment {}

let giftReducer = Reducer<GiftState, GiftAction, GiftEnvironment> {
  state, action, environment in
  
  switch action {
  case .startEditing:
    return .none
    
  case .endEditing:
    return .none
    
  case .toggleFavourite:
    state.gift.favourite.toggle()
    return .none

  case let .textFieldChanged(name):
    state.gift.name = name
    return .none
  }
}
