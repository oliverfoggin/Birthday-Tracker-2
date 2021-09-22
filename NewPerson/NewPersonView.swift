//
//  NewPersonView.swift
//  NewPersonView
//
//  Created by Foggin, Oliver (Developer) on 07/09/2021.
//

import SwiftUI
import ComposableArchitecture

public struct NewPersonView: View {
  let store: Store<NewPersonState, NewPersonAction>
  
  public init(store: Store<NewPersonState, NewPersonAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        Form {
          TextField("Name", text: viewStore.binding(\.$name))
          DatePicker("DOB", selection: viewStore.binding(\.$dob), displayedComponents: [.date])
        }
        .navigationTitle("New Person")
        .toolbar {
          ToolbarItem(placement: .confirmationAction) {
            Button("Save") {
              viewStore.send(.saveButtonTapped)
            }
            .disabled(viewStore.saveButtonDisabled)
          }
          ToolbarItem(placement: .cancellationAction) {
            Button("Cancel") {
              viewStore.send(.cancelButtonTapped)
            }
          }
        }
      }
    }
  }
}

struct NewPersonView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      NewPersonView(
        store: Store(
          initialState: .init(dob: Date()),
          reducer: newPersonReducer,
          environment: .init()
        )
      )
    }
  }
}
