//
//  View.swift
//  View
//
//  Created by Foggin, Oliver (Developer) on 13/09/2021.
//

import SwiftUI
import ComposableArchitecture

extension View {
  func synchronize<Value: Equatable>(
    _ first: Binding<Value>,
    _ second: FocusState<Value>.Binding
  ) -> some View {
    self
      .onChange(of: first.wrappedValue) { second.wrappedValue = $0 }
      .onChange(of: second.wrappedValue) { first.wrappedValue = $0 }
  }
}
