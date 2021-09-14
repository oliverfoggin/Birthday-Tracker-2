//
//  EditView.swift
//  EditView
//
//  Created by Foggin, Oliver (Developer) on 07/09/2021.
//

import SwiftUI
import ComposableArchitecture

public struct PersonEditView: View {
  let store: Store<PersonState, PersonAction>
  
  @Environment(\.presentationMode) var presentationMode
  
  public var body: some View {
    WithViewStore(store.scope(state: \.editState, action: PersonAction.editAction)) { viewStore in
      NavigationView {
        Form {
          TextField("Name", text: viewStore.$person.name)
          DatePicker("DOB", selection: viewStore.$person.dob, displayedComponents: [.date])
        }
        .navigationTitle("Edit")
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button("Done") {
              presentationMode.wrappedValue.dismiss()
            }
          }
        }
      }
    }
  }
}
