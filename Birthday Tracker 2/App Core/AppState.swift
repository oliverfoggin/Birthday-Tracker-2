//
//  AppState.swift
//  AppState
//
//  Created by Foggin, Oliver (Developer) on 07/09/2021.
//

import SwiftUI
import ComposableArchitecture

struct AppState: Equatable {
  enum Sort: LocalizedStringKey, CaseIterable, Hashable {
    case age = "Age"
    case nextBirthday = "Next Birthday"
  }
  
  var sortedPeople: IdentifiedArrayOf<PersonState> = []
  
  @BindableState var sort: Sort = .age
  
  var newPersonState: NewPersonState?
  @BindableState var isNewPersonSheetPresented = false
}

enum AppAction: BindableAction {
  case onAppear
  case personAction(id: Person.ID, action: PersonAction)
  case addPersonButtonTapped
  case newPersonAction(NewPersonAction)
  case delete(IndexSet)
  case binding(BindingAction<AppState>)
  case sortPeople
  case saveData
  case loadData
  case loadResults(Result<[Person], Never>)
}

struct AppEnvironment {
  var uuid: () -> UUID
  var now: () -> Date
  var calendar: Calendar
  var fileClient: FileClient
  var fileName: String
}

extension AppEnvironment {
  static var live: Self = Self.init(
    uuid: UUID.init,
    now: Date.init,
    calendar: .current,
    fileClient: .live,
    fileName: "file.json"
  )
}

let appReducer = Reducer.combine(
  personReducer.forEach(
    state: \.sortedPeople,
    action: /AppAction.personAction(id:action:),
    environment: { _ in PersonEnvironment() }
  ),
  newPersonReducer
    .optional().pullback(
      state: \.newPersonState,
      action: /AppAction.newPersonAction,
      environment: { _ in NewPersonEnvironment() }
    ),
  Reducer<AppState, AppAction, AppEnvironment> {
    state, action, environment in
    switch action {
    case .onAppear:
      return Effect(value: .loadData)
      
    case .loadData:
      return environment.fileClient
        .load(environment.fileName)
        .catchToEffect(AppAction.loadResults)
    case .saveData:
      return environment.fileClient
        .save(state.sortedPeople.map(\.person), environment.fileName)
        .fireAndForget()
    case let .loadResults(.success(people)):
      state.sortedPeople = people.map { PersonState(person: $0) }.identified
      return Effect(value: .sortPeople)
      
    case .personAction(id: _, action: PersonAction.editAction):
      return Effect.merge(Effect(value: .saveData), Effect(value: .sortPeople))
    case .personAction:
      return .none
    case .addPersonButtonTapped:
      state.newPersonState = NewPersonState(dob: environment.now())
      state.isNewPersonSheetPresented = true
      return .none
      
    case .newPersonAction(.cancelButtonTapped):
      state.isNewPersonSheetPresented = false
      state.newPersonState = nil
      return .none
      
    case .newPersonAction(.saveButtonTapped):
      guard let newPerson = state.newPersonState else {
        return .none
      }
      
      state.sortedPeople.append(
        PersonState(
          person: Person(
            id: environment.uuid(),
            name: newPerson.name,
            dob: newPerson.dob
          )
        )
      )
      
      state.newPersonState = nil
      state.isNewPersonSheetPresented = false
      
      return Effect.merge(Effect(value: .saveData), Effect(value: .sortPeople))
    case .newPersonAction:
      return .none
    case .sortPeople:
      if state.sort == .age {
        state.sortedPeople = state.sortedPeople
          .sorted(by: \.person.dob)
          .map { $0.with(subtitle: .age) }
          .identified
      } else {
        state.sortedPeople = state.sortedPeople
          .sorted { $0.person.nextBirthday(now: environment.now(), calendar: environment.calendar) < $1.person.nextBirthday(now: environment.now(), calendar: environment.calendar) }
          .map { $0.with(subtitle: .birthday) }
          .identified
      }
      return .none
      
    case let .delete(indexSet):
      state.sortedPeople.remove(atOffsets: indexSet)
      return Effect.merge(Effect(value: .saveData), Effect(value: .sortPeople))
      
    case .binding(\.$isNewPersonSheetPresented):
      if state.isNewPersonSheetPresented == false {
        state.newPersonState = nil
      }
      return .none
    case .binding(\.$sort):
      return Effect(value: .sortPeople)
    case .binding(_):
      return .none
    }
  }
  .binding()
)
.debug()
