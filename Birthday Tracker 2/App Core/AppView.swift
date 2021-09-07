//
//  ContentView.swift
//  Birthday Tracker 2
//
//  Created by Foggin, Oliver (Developer) on 07/09/2021.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
  let store: Store<AppState, AppAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        VStack {
          Picker("Sort:", selection: viewStore.$sort.animation()) {
            ForEach(AppState.Sort.allCases, id: \.self) { sort in
              Text(sort.rawValue).tag(sort)
            }
          }
          .pickerStyle(SegmentedPickerStyle())
          .padding(.horizontal)
          List {
            ForEachStore(store.scope(state: \.sortedPeople, action: AppAction.personAction(id:action:))) { personStore in
              NavigationLink {
                PersonDetailView(store: personStore)
              } label: {
                PersonListView(store: personStore)
              }
            }
            .onDelete { viewStore.send(.delete($0)) }
          }
        }
        .sheet(isPresented: viewStore.$isNewPersonSheetPresented) {
          IfLetStore(
            self.store.scope(
              state: \.newPersonState,
              action: AppAction.newPersonAction
            ),
            then: NewPersonView.init(store:)
          )
        }
        .navigationTitle("Birthdays")
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button {
              viewStore.send(.addPersonButtonTapped)
            } label: {
              Image(systemName: "plus.circle")
            }
          }
        }
      }
      .onAppear {
        viewStore.send(.onAppear)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(
      store: Store(
        initialState: .init(
          sortedPeople: [
            PersonState(person: Person(id: UUID(), name: "Oliver", dob: Date())),
            PersonState(person: Person(id: UUID(), name: "David", dob: Date())),
          ]
        ),
        reducer: appReducer,
        environment: .live
      )
    )
  }
}
