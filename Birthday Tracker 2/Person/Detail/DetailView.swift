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
  
  var detailStore: Store<PersonState.DetailState, PersonState.DetailAction> {
    store.scope(state: \.detailState, action: PersonAction.detailAction)
  }
  
  static var dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateStyle = .medium
    df.timeStyle = .none
    return df
  }()
  
  var body: some View {
    WithViewStore(detailStore) { viewStore in
      VStack(alignment: HorizontalAlignment.leading) {
        List {
          Section {
            Text(PersonDetailView.dateFormatter.string(from: viewStore.person.dob))
          } header: {
            Text("Date of Birth")
          }
          
          Section {
            ForEachStore(
              detailStore.scope(state: \.giftIdeas, action: PersonState.DetailAction.giftAction(id:action:)),
              content: GiftIdeaListView.init(store:)
            )
              .onDelete { viewStore.send(.deleteGift($0)) }
          } header: {
            HStack {
              Text("Gift Ideas")
              Spacer()
              Button {
                viewStore.send(.addGiftIdeaButtonTapped)
              } label: {
                Image(systemName: "plus.circle")
              }
            }
          }
        }
      }
      .onAppear { viewStore.send(.onAppear) }
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
