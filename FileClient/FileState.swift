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
  public enum LoadingState: Equatable {
    case notAsked
    case loading
    case loaded(people: [Person])
  }
  
  public var loadingState: LoadingState = .notAsked
  
  public init() {}
}

public enum FileAction {
  case load
  case save([Person])
  case loadResults(Result<[Person], Never>)
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
    
    case .load:
      return environment.fileClient
        .load(environment.fileName)
        .catchToEffect(FileAction.loadResults)
    case let .save(people):
      return environment.fileClient
        .save(people, environment.fileName)
        .fireAndForget()
    case let .loadResults(.success(people)):
    state.loadingState = .loaded(people: people)
    return .none
  }
}
