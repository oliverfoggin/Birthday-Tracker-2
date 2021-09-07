//
//  PersonViews.swift
//  PersonViews
//
//  Created by Foggin, Oliver (Developer) on 07/09/2021.
//

import SwiftUI
import ComposableArchitecture

struct PersonDetailView: View {
  let store: Store<PersonState, PersonAction>
    
  var body: some View {
    WithViewStore(store.scope(state: \.detailState, action: PersonAction.detailAction)) { viewStore in
      List {
        Text(viewStore.person.name)
        Text(viewStore.person.id.uuidString)
      }
      .sheet(isPresented: viewStore.$isEditSheetPresented) {
        PersonEditView(store: store)
      }
      .navigationTitle(viewStore.person.name)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            viewStore.send(.set(\.$isEditSheetPresented, true))
          } label: {
            Text("Edit")
          }
        }
      }
    }
  }
}
