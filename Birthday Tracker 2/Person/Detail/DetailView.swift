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
    
  static var dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateStyle = .medium
    df.timeStyle = .none
    return df
  }()
  
  var body: some View {
    WithViewStore(store.scope(state: \.detailState, action: PersonAction.detailAction)) { viewStore in
      VStack(alignment: HorizontalAlignment.leading) {
        Text(viewStore.person.name)
          .padding()
        Text(PersonDetailView.dateFormatter.string(from: viewStore.person.dob))
          .padding()
        Section {
          List {
            ForEach(viewStore.person.giftIdeas) { giftIdea in
              HStack{
                Image(systemName: "star")
                Text(giftIdea.name)
                Spacer()
                Image(systemName: "checkmark.square")
              }
            }
          }
        } header: {
          HStack {
            Text("Gift Ideas")
              .font(.title)
            Spacer()
            Button {
              viewStore.send(.addGiftIdeaButtonTapped)
            } label: {
              Image(systemName: "plus.circle")
            }
          }
          .padding()
        }
        Spacer()
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
