//
//  PersonViews.swift
//  PersonViews
//
//  Created by Foggin, Oliver (Developer) on 07/09/2021.
//

import SwiftUI
import ComposableArchitecture

public struct PersonDetailView: View {
  let store: Store<PersonState, PersonAction>
  
  public init(store: Store<PersonState, PersonAction>) {
    self.store = store
  }
  
  var detailStore: Store<PersonState.DetailState, PersonState.DetailAction> {
    store.scope(state: \.detailState, action: PersonAction.detailAction)
  }
  
  static var dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateStyle = .medium
    df.timeStyle = .none
    return df
  }()
  
  public var body: some View {
    WithViewStore(detailStore) { viewStore in
      VStack(alignment: HorizontalAlignment.leading) {
        List {
          Section {
            Text(PersonDetailView.dateFormatter.string(from: viewStore.person.dob))
          } header: {
            Text("Date of Birth")
          }
          
          Section {
            ForEachStore(detailStore.scope(state: \.giftIdeas, action: PersonState.DetailAction.giftAction(id:action:))) {
              GiftIdeaListView(store: $0)
            }
          } header: {
            HStack {
              Text("Gift Ideas")
              Spacer()
              Button {
                viewStore.send(.addGiftIdeaButtonTapped, animation: .default)
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
