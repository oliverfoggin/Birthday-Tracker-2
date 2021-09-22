//
//  FileState.swift
//  FileState
//
//  Created by Foggin, Oliver (Developer) on 18/09/2021.
//

import Foundation
import ComposableArchitecture
import Common

public struct FileState: Equatable {
  public enum LoadingState<T: Equatable>: Equatable {
    case notAsked
    case loading
    case loaded(data: T)
  }
  
  public var peopleLoadingState: LoadingState<[Person]> = .notAsked
  
  public init() {}
}

public enum FileAction {
  case loadPeople
  case savePeople([Person])
  case loadPeopleResults(Result<[Person], Never>)
}

public struct FileEnvironment {
  let fileClient: FileClient
  let fileName: String
  
  public init(fileClient: FileClient, fileName: String) {
    self.fileClient = fileClient
    self.fileName = fileName
  }
}

public extension FileEnvironment {
  static var live: Self = Self.init(
    fileClient: .live,
    fileName: "file.json"
  )
}

public let fileReducer = Reducer<FileState, FileAction, FileEnvironment> {
  state, action, environment in
  
  switch action {
    
    case .loadPeople:
      return environment.fileClient
        .load(environment.fileName)
        .catchToEffect(FileAction.loadPeopleResults)
    case let .savePeople(people):
      return environment.fileClient
        .save(people, environment.fileName)
        .fireAndForget()
    case let .loadPeopleResults(.success(people)):
    state.peopleLoadingState = .loaded(data: people)
    return .none
  }
}
