//
//  PersonState.swift
//  PersonState
//
//  Created by Foggin, Oliver (Developer) on 07/09/2021.
//

import Foundation
import ComposableArchitecture
import UIKit

struct PersonState: Equatable, Identifiable {
  var person: Person
  
  var id: UUID { person.id }
  var isEditSheetPresented = false
}

extension PersonState {
  struct ListViewModel: Equatable {
    var title: String
    var subtitle: String
    
    static var dateFormatter: DateFormatter {
      let df = DateFormatter()
      df.dateFormat = "dd MMM YYYY"
      return df
    }
  }
  
  var listViewModel: ListViewModel {
    ListViewModel(title: person.name, subtitle: ListViewModel.dateFormatter.string(from: person.dob))
  }
}

extension PersonState {
  struct DetailState: Equatable {
    var person: Person
    @BindableState var isEditSheetPresented: Bool
  }
 
  enum DetailAction: BindableAction {
    case binding(BindingAction<DetailState>)
  }
  
  var detailState: DetailState {
    get {
      DetailState(
        person: person,
        isEditSheetPresented: isEditSheetPresented
      )
    }
    set {
      person = newValue.person
      isEditSheetPresented = newValue.isEditSheetPresented
    }
  }
}

extension PersonState {
  struct EditState: Equatable {
    @BindableState var person: Person
  }
  
  enum EditAction: BindableAction {
    case binding(BindingAction<EditState>)
  }
  
  var editState: EditState {
    get { EditState(person: person) }
    set { person = newValue.person }
  }
}

let personEditReducer = Reducer<PersonState.EditState, PersonState.EditAction, PersonEnvironment> {
  state, action, environment in
  
  switch action {
  case .binding:
    return .none
  }
}
  .binding()

let personDetailReducer = Reducer<PersonState.DetailState, PersonState.DetailAction, PersonEnvironment> {
  state, action, environment in
  
  switch action {
  case .binding:
    return .none
  }
}
  .binding()

enum PersonAction {
  case detailAction(PersonState.DetailAction)
  case editAction(PersonState.EditAction)
}

struct PersonEnvironment {}

let personReducer = Reducer.combine(
  personDetailReducer.pullback(
    state: \.detailState,
    action: /PersonAction.detailAction,
    environment: { _ in PersonEnvironment() }
  ),
  personEditReducer.pullback(
    state: \.editState,
    action: /PersonAction.editAction,
    environment: { _ in PersonEnvironment() }
  ),
  Reducer<PersonState, PersonAction, PersonEnvironment> {
    state, action, environment in
    
    switch action {
    case .detailAction:
      return .none
    case .editAction:
      return .none
    }
  }
)
