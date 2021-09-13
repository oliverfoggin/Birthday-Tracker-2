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
    var isEditingGiftName: Bool
    var giftIdeas: IdentifiedArrayOf<GiftState> {
      didSet { person.giftIdeas = giftIdeas.map(\.gift).identified }
    }
    
    init(person: Person, isEditSheetPresented: Bool, isEditingGiftName: Bool) {
      self.person = person
      self.isEditSheetPresented = isEditSheetPresented
      self.isEditingGiftName = isEditingGiftName
      self.giftIdeas = person.giftIdeas.map(GiftState.init(gift:)).identified
    }
  }
 
  enum DetailAction: BindableAction {
    case onAppear
    case binding(BindingAction<DetailState>)
    case addGiftIdeaButtonTapped
    case giftAction(id: GiftState.ID, action: GiftAction)
    case sortGifts
    case deleteGift(IndexSet)
  }
  
  var detailState: DetailState {
    get {
      DetailState(
        person: person,
        isEditSheetPresented: isEditSheetPresented,
        isEditingGiftName: isEditingGiftName
      )
    }
    set {
      person = newValue.person
      isEditSheetPresented = newValue.isEditSheetPresented
      isEditingGiftName = newValue.isEditingGiftName
    }
  }
}

let personDetailReducer = Reducer<PersonState.DetailState, PersonState.DetailAction, PersonEnvironment>.combine(
  giftReducer.forEach(
    state: \.giftIdeas,
    action: /PersonState.DetailAction.giftAction(id:action:),
    environment: { _ in GiftEnvironment() }
  ),
  Reducer<PersonState.DetailState, PersonState.DetailAction, PersonEnvironment> {
    state, action, environment in
    
    switch action {
    case .onAppear:
      return Effect(value: .sortGifts)
    case .addGiftIdeaButtonTapped:
      state.person.giftIdeas.append(Person.GiftIdea(id: UUID(), name: "", favourite: false))
      return .none
    case .binding:
      return .none
      
    case let .giftAction(id: id, action: GiftAction.toggleFavourite):
      struct GiftFavouriteCompletionId: Hashable {}
      
      guard let giftState = state.giftIdeas[id: id] else { return .none }
      
      state.person.giftIdeas[id: id] = giftState.gift
      return Effect(value: .sortGifts)
        .debounce(id: GiftFavouriteCompletionId(), for: .milliseconds(300), scheduler: environment.main.animation())
      
    case let .giftAction(id: id, action: GiftAction.textFieldChanged):
      struct GiftNameCompletionId: Hashable {}
      
      if state.isEditingGiftName {
        return .none
      } else {
        return Effect(value: .sortGifts)
          .debounce(id: GiftNameCompletionId(), for: .milliseconds(300), scheduler: environment.main.animation())
      }
      
    case .giftAction(id: let id, action: .binding(.set(\.$focusedField, nil))):
      state.isEditingGiftName = false
      return Effect(value: .sortGifts)
        .receive(on: environment.main.animation())
        .eraseToEffect()

    case .giftAction(id: let id, action: .binding(\.$focusedField)):
      state.isEditingGiftName = true
      return .none
      
    case .giftAction:
      return .none
      
    case .sortGifts:
      state.giftIdeas = state.giftIdeas
        .sorted {
          if $0.gift.favourite && !$1.gift.favourite {
            return true
          }
          
          if !$0.gift.favourite && $1.gift.favourite {
            return false
          }
          
          return $0.gift.name < $1.gift.name
        }
        .identified
      return .none
    case let .deleteGift(indexSet):
      state.giftIdeas.remove(atOffsets: indexSet)
      return .none
    }
  }.binding()
)
