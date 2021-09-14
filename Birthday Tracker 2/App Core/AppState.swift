//
//  AppState.swift
//  AppState
//
//  Created by Foggin, Oliver (Developer) on 07/09/2021.
//

import SwiftUI
import ComposableArchitecture
import Common
import PersonState
import FileClient
import NewPerson

struct AppState: Equatable {
  enum Sort: LocalizedStringKey, CaseIterable, Hashable {
    case age = "Age"
    case nextBirthday = "Next Birthday"
  }
  
  var people: IdentifiedArrayOf<PersonState> = []
  
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
  var main: AnySchedulerOf<DispatchQueue>
}

extension AppEnvironment {
  static var live: Self = Self.init(
    uuid: UUID.init,
    now: Date.init,
    calendar: .current,
    fileClient: .live,
    fileName: "file.json",
    main: .main
  )
}

let appReducer = Reducer.combine(
  personReducer.forEach(
    state: \.people,
    action: /AppAction.personAction(id:action:),
    environment: { env in PersonEnvironment(main: env.main, uuid: env.uuid) }
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
    // On Appear
    case .onAppear:
      return Effect(value: .loadData)
      
    // Loading and saving
    case .loadData:
      return environment.fileClient
        .load(environment.fileName)
        .catchToEffect(AppAction.loadResults)
    case .saveData:
      return environment.fileClient
        .save(state.people.map(\.person), environment.fileName)
        .fireAndForget()
    case let .loadResults(.success(people)):
      state.people = people.map {
        PersonState(person: $0, now: environment.now, calendar: environment.calendar)
      }.identified
      return Effect(value: .sortPeople)
      
    // Person actions
    case .personAction(id: _, action: .editAction):
      return Effect.merge(Effect(value: .saveData), Effect(value: .sortPeople))
    case .personAction(id: _, action: .detailAction(.giftAction(id: _, action: .binding(.set(\.$focusedField, nil))))):
      return Effect(value: .saveData)
    case .personAction(id: _, action: .detailAction(.giftAction(id: _, action: .toggleFavourite))):
      return Effect(value: .saveData)
    case .personAction(id: _, action: .detailAction(.giftAction(id: _, action: .toggleBought))):
      return Effect(value: .saveData)
    case .personAction:
      return .none
      
    // New person
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
      
      state.people.append(
        PersonState(
          person: Person(
            id: environment.uuid(),
            name: newPerson.name,
            dob: newPerson.dob
          ),
          now: environment.now,
          calendar: environment.calendar
        )
      )
      
      state.newPersonState = nil
      state.isNewPersonSheetPresented = false
      
      return Effect.merge(Effect(value: .saveData), Effect(value: .sortPeople))
    case .newPersonAction:
      return .none
      
    // Sorting people
    case .sortPeople:
      if state.sort == .age {
        state.people = state.people
          .sorted(by: \.person.dob)
          .map { $0.with(\.subtitle, value: .age) }
          .identified
      } else {
        state.people = state.people
          .sorted { $0.person.nextBirthday(now: environment.now(), calendar: environment.calendar) < $1.person.nextBirthday(now: environment.now(), calendar: environment.calendar) }
          .map { $0.with(\.subtitle, value: .birthday) }
          .identified
      }
      return .none
      
    // Deleting
    case let .delete(indexSet):
      state.people.remove(atOffsets: indexSet)
      return Effect.merge(Effect(value: .saveData), Effect(value: .sortPeople))
      
    // Bindings
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
