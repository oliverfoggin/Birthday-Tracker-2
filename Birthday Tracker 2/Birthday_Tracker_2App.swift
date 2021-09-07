//
//  Birthday_Tracker_2App.swift
//  Birthday Tracker 2
//
//  Created by Foggin, Oliver (Developer) on 07/09/2021.
//

import SwiftUI
import ComposableArchitecture

@main
struct Birthday_Tracker_2App: App {
  var body: some Scene {
    WindowGroup {
      ContentView(
        store: Store(
          initialState: .init(),
          reducer: appReducer,
          environment: .live
        )
      )
    }
  }
}
