//
//  ListView.swift
//  ListView
//
//  Created by Foggin, Oliver (Developer) on 07/09/2021.
//

import SwiftUI
import ComposableArchitecture

struct PersonListView: View {
  let store: Store<PersonState, PersonAction>
  
  var body: some View {
    WithViewStore(store.scope(state: \.listViewModel)) { s in
      HStack {
        Text(s.title)
        Spacer()
        Text(s.subtitle).font(.caption)
      }
    }
  }
}
