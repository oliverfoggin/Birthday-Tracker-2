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
          TextField("Name", text: viewStore.$name)
          DatePicker("DOB", selection: viewStore.$dob, displayedComponents: [.date])
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
