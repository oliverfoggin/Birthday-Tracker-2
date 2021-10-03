//
//  DeatilView.swift
//  GiftIdeas
//
//  Created by Foggin, Oliver (Developer) on 03/10/2021.
//

import SwiftUI
import ComposableArchitecture

public struct NotesView: View {
  let store: Store<NotesState, NotesAction>
  
  public init(store: Store<NotesState, NotesAction>) {
    self.store = store
  }
  
  public var body: some View {
    WithViewStore(store) { viewStore in
      TextEditor(text: viewStore.binding(\.$notes))
        .padding()
        .navigationTitle(viewStore.name)
    }
  }
}
