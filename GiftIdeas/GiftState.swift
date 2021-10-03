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
  
  public var giftNotes: NotesState {
    get {
      NotesState(name: gift.name, notes: gift.notes)
    }
    set {
      gift.notes = newValue.notes
    }
  }
  
  public init(gift: Person.GiftIdea) {
    self.gift = gift
  }
}

public enum GiftAction: BindableAction {
  case toggleFavourite
  case textFieldChanged(String)
  case toggleBought
  case delete
  case notesAction(NotesAction)
  case binding(BindingAction<GiftState>)
}

public struct GiftEnvironment {
  public init() {
  }
}

public let giftReducer = Reducer.combine(
  notesReducer.pullback(
    state: \GiftState.giftNotes,
    action: /GiftAction.notesAction,
    environment: { _ in NotesEnvironment() }
  ),
  Reducer<GiftState, GiftAction, GiftEnvironment> {
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
      
    case .notesAction:
      return .none
      
    case .binding:
      return .none
    }
  }
    .binding()
)
