//
//  NewPersonView.swift
//  NewPersonView
//
//  Created by Foggin, Oliver (Developer) on 07/09/2021.
//

import SwiftUI
import ComposableArchitecture
import ImagePicker

public struct NewPersonView: View {
  let store: Store<NewPersonState, NewPersonAction>
  
  public init(store: Store<NewPersonState, NewPersonAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        List {
          Section("Photo") {
            Button {
              viewStore.send(.imagePickerAction(action: .setSheet(isPresented: true)))
            } label: {
              if let image = viewStore.imagePickerState.image {
                Image(uiImage: image)
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .clipped()
              } else {
                PersonAvatarButton()
              }
            }
          }
          .aspectRatio(1, contentMode: .fill)
          .listRowBackground(Color.gray)
          .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
          .sheet(isPresented: viewStore.binding(\.$imagePickerState.showingImagePicker)) {
            ImagePicker(store: store.scope(state: \.imagePickerState, action: NewPersonAction.imagePickerAction(action:)))
          }
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

struct PersonAvatarButton: View {
  var body: some View {
    VStack {
      Spacer()
      HStack {
        Spacer()
        Image(systemName: "person")
          .resizable()
          .frame(width: 50, height: 50)
          .foregroundColor(.black)
        Spacer()
      }
      Spacer()
    }
  }
}

struct NewPersonView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      NewPersonView(
        store: Store(
          initialState: NewPersonState(dob: Date()),
          reducer: newPersonReducer,
          environment: .init()
        )
      )
    }
  }
}
