//
//  NewPersonTests.swift
//  NewPersonTests
//
//  Created by Foggin, Oliver (Developer) on 15/09/2021.
//

import XCTest
@testable import NewPerson

import ComposableArchitecture

class NewPersonTests: XCTestCase {
  func test() throws {
    let testStore = TestStore(
      initialState: .init(dob: Date(timeIntervalSince1970: 0)),
      reducer: newPersonReducer,
      environment: .init()
    )
    
    testStore.send(.binding(.set(\.$name, "Oliver"))) {
      $0.name = "Oliver"
    }
    testStore.send(.binding(.set(\.$dob, Date(timeIntervalSince1970: 100)))) {
      $0.dob = Date(timeIntervalSince1970: 100)
    }
  }
}
