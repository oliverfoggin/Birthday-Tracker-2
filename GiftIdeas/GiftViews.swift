//
//  GiftViews.swift
//  GiftViews
//
//  Created by Foggin, Oliver (Developer) on 13/09/2021.
//

import SwiftUI
import ComposableArchitecture

public struct GiftIdeaListView: View {
  let store: Store<GiftState, GiftAction>
  @FocusState var focusedField: GiftState.Field?
  
  public init(store: Store<GiftState, GiftAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      NavigationLink {
        DetailView(store: store.scope(state: \.giftNotes, action: GiftAction.notesAction))
      } label: {
        HStack {
          TextField("Name", text: viewStore.binding(get: \.gift.name, send: GiftAction.textFieldChanged))
            .focused($focusedField, equals: .name)
          
          Spacer()
          
          Button {
            viewStore.send(.toggleFavourite, animation: .default)
          } label: {
            switch (viewStore.gift.bought, viewStore.gift.favourite) {
            case (false, false):
              Image(systemName: "star")
            case (false, true):
              Image(systemName: "star.fill")
            case (true, false):
              Image(systemName: "star.slash")
            case (true, true):
              Image(systemName: "star.slash.fill")
            }
          }
        }
        .synchronize(viewStore.binding(\.$focusedField), self.$focusedField)
        .swipeActions(edge: .leading, allowsFullSwipe: true) {
          Button {
            viewStore.send(.toggleBought)
          } label: {
            Image(systemName: viewStore.gift.bought ? "xmark" : "checkmark")
          }
        }
        .swipeActions(edge: .trailing) {
          Button(role: .destructive) {
            viewStore.send(.delete, animation: .default)
          } label: {
            Label("Delete", systemImage: "trash")
          }
        }
      }
    }
  }
}
