//
//  DetailState.swift
//  GiftIdeas
//
//  Created by Foggin, Oliver (Developer) on 03/10/2021.
//

import Foundation
import ComposableArchitecture
import Common

public struct NotesState: Equatable {
  var name: String
  @BindableState var notes: String
}

public enum NotesAction: BindableAction {
  case binding(BindingAction<NotesState>)
}

public struct NotesEnvironment {}

public let notesReducer = Reducer<NotesState, NotesAction, NotesEnvironment> {
  _, _, _ in .none
}
.binding()
