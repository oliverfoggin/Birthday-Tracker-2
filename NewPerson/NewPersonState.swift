//
//  NewState.swift
//  NewState
//
//  Created by Foggin, Oliver (Developer) on 07/09/2021.
//

import Foundation
import ComposableArchitecture
import Common
import ImagePicker

public struct NewPersonState: Equatable {
  @BindableState public var dob: Date
  @BindableState public var name: String = ""
  @BindableState var imagePickerState: ImagePickerState = .init(showingImagePicker: false)
  
  var saveButtonDisabled: Bool {
    name.isEmpty
  }
  
  public init(dob: Date) {
    self.dob = dob
  }
}

public enum NewPersonAction: BindableAction {
  case binding(BindingAction<NewPersonState>)
  case saveButtonTapped
  case cancelButtonTapped
  
  case imagePickerAction(action: ImagePickerAction)
}

public struct NewPersonEnvironment {
  public init() {}
}

public let newPersonReducer = Reducer.combine(
  imagePickerReducer.pullback(
    state: \.imagePickerState,
    action: /NewPersonAction.imagePickerAction(action:),
    environment: { _ in ImagePickerEnvironment() }
  ),
  Reducer<NewPersonState, NewPersonAction, NewPersonEnvironment> {
    state, action, environment in
    
    switch action {
    case .binding:
      return .none
    case .saveButtonTapped:
      return .none
    case .cancelButtonTapped:
      return .none
      
    case .imagePickerAction:
      return .none
    }
  }
  .binding()
)

