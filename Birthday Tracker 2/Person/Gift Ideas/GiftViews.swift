//
//  GiftViews.swift
//  GiftViews
//
//  Created by Foggin, Oliver (Developer) on 13/09/2021.
//

import SwiftUI
import ComposableArchitecture

struct GiftIdeaListView: View {
  let store: Store<GiftState, GiftAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      HStack {
        TextField("Name", text: viewStore.binding(get: \.gift.name, send: GiftAction.textFieldChanged))
          .onFocus { viewStore.send($0 ? .startEditing : .endEditing) }

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
      .swipeActions(edge: .leading, allowsFullSwipe: true) {
        Button {
          viewStore.send(.toggleBought)
        } label: {
          Image(systemName: viewStore.gift.bought ? "xmark" : "checkmark")
        }
      }
    }
  }
}
