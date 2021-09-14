//
//  GiftState.swift
//  GiftState
//
//  Created by Foggin, Oliver (Developer) on 13/09/2021.
//

import Foundation
import ComposableArchitecture
import Common

public struct GiftState: Equatable, Identifiable {
  public enum Field: String, Hashable {
    case name
  }
  
  public var gift: Person.GiftIdea
  public var id: UUID { gift.id }
  @BindableState public var focusedField: Field?
  
  public init(gift: Person.GiftIdea) {
    self.gift = gift
  }
}

public enum GiftAction: BindableAction {
  case toggleFavourite
  case textFieldChanged(String)
  case toggleBought
//  case setFocusedField(GiftState.Field?)
  case delete
  case binding(BindingAction<GiftState>)
}

public struct GiftEnvironment {}

public let giftReducer = Reducer<GiftState, GiftAction, GiftEnvironment> {
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
  
  case .delete:
    return .none
    
  case .binding:
    return .none
  }
}
  .binding()
