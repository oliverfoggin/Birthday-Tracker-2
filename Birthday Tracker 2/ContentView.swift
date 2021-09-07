//
//  ContentView.swift
//  Birthday Tracker 2
//
//  Created by Foggin, Oliver (Developer) on 07/09/2021.
//

import SwiftUI
import ComposableArchitecture

struct Person: Equatable, Identifiable {
  var id: UUID
  var name: String
  var dob: Date
}

struct AppState: Equatable {
  var people: IdentifiedArrayOf<Person> = []
  
  var sortedPeople: IdentifiedArrayOf<PersonState> = []
}

enum AppAction {
  case personAction(id: Person.ID, action: PersonAction)
}

struct AppEnvironment {}

let appReducer = Reducer.combine(
  personReducer.forEach(
    state: \.sortedPeople,
    action: /AppAction.personAction(id:action:),
    environment: { _ in PersonEnvironment() }
  ),
  Reducer<AppState, AppAction, AppEnvironment> {
    state, action, environment in
    switch action {
    case .personAction:
      return .none
    }
  }
)
  .debug()

struct ContentView: View {
  let store: Store<AppState, AppAction>
  
  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        List {
          ForEachStore(
            store.scope(state: \.sortedPeople, action: AppAction.personAction(id:action:))) { personStore in
              NavigationLink {
                PersonDetailView(store: personStore)
              } label: {
                PersonListView(store: personStore)
              }
            }
        }
        .navigationTitle("Birthdays")
      }
    }
  }
}

struct PersonListView: View {
  let store: Store<PersonState, PersonAction>
  
  var body: some View {
    WithViewStore(store.scope(state: \.listViewModel)) { s in
      HStack {
        Text(s.title)
        Spacer()
        Text(s.subtitle)
          .font(.caption)
      }
    }
  }
}

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

struct PersonEditView: View {
  let store: Store<PersonState, PersonAction>
  
  var body: some View {
    WithViewStore(store.scope(state: \.editState, action: PersonAction.editAction)) { viewStore in
      Form {
        TextField("Name", text: viewStore.$person.name)
        DatePicker("DOB", selection: viewStore.$person.dob, displayedComponents: [.date])
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
        environment: .init()
      )
    )
  }
}
