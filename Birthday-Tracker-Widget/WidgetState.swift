//
//  WidgetState.swift
//  WidgetState
//
//  Created by Foggin, Oliver (Developer) on 19/09/2021.
//

import Foundation
import Common
import ComposableArchitecture
import FileClient

struct WidgetState: Equatable {
  var people: IdentifiedArrayOf<Person> = []
  
  var fileState = FileState()
}

enum WidgetAction {
  case onAppear
  case fileAction(FileAction)
}

struct WidgetEnvironment {
  let fileEnvironment: FileEnvironment
}

extension WidgetEnvironment {
  static var live: Self = .init(
    fileEnvironment: .live
  )
}

let widgetReducer = Reducer.combine(
  fileReducer.pullback(
    state: \.fileState,
    action: /WidgetAction.fileAction,
    environment: { $0.fileEnvironment }
  ),
  Reducer<WidgetState, WidgetAction, WidgetEnvironment> {
    state, action, environment in
    
    switch action {
    case .onAppear:
      return Effect(value: .fileAction(.load))
      
    case let .fileAction(.loadResults(.success(people))):
      state.people = people.identified
      return .none
      
    case .fileAction:
      return .none
    }
  }
)
  .debug()
