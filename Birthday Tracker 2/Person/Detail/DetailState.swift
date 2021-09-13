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
    
    var giftIdeas: IdentifiedArrayOf<GiftState> {
      get { person.giftIdeas.map(GiftState.init(gift:)).identified }
      set { person.giftIdeas = newValue.map(\.gift).identified }
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
        isEditSheetPresented: isEditSheetPresented
      )
    }
    set {
      person = newValue.person
      isEditSheetPresented = newValue.isEditSheetPresented
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
    case let .giftAction(id: id, action: _):
      if let gift = state.giftIdeas[id: id], gift.isEditing {
        return .none
      } else {
        return Effect(value: .sortGifts)
          .delay(for: .milliseconds(300), scheduler: environment.main.animation())
          .eraseToEffect()
      }
    case .sortGifts:
      state.person.giftIdeas = state.person
        .giftIdeas
        .sorted {
          if $0.favourite && !$1.favourite {
            return true
          }
          
          if !$0.favourite && $1.favourite {
            return false
          }
          
          return $0.name < $1.name
        }
        .identified
      return .none
    case let .deleteGift(indexSet):
      state.giftIdeas.remove(atOffsets: indexSet)
      return .none
    }
  }.binding()
)
