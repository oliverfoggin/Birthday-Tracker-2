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
        TextField(
          "Name",
          text: viewStore.binding(get: \.gift.name, send: GiftAction.textFieldChanged)
        )
        .onFocus { isFocused in
          viewStore.send(isFocused ? .startEditing : .endEditing)
        }

        Spacer()
        
        Button {
          viewStore.send(.toggleFavourite, animation: .default)
        } label: {
          Image(systemName: viewStore.gift.favourite ? "star.fill" : "star")
        }
      }
    }
  }
}
