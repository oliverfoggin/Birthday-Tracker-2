//
//  ListViewModel.swift
//  ListViewModel
//
//  Created by Foggin, Oliver (Developer) on 07/09/2021.
//

import Foundation

extension PersonState {
  struct ListViewModel: Equatable {
    var title: String
    var subtitle: String
    
    static var dateFormatter: DateFormatter {
      let df = DateFormatter()
      df.dateFormat = "dd MMM YYYY"
      return df
    }
  }
  
  var listViewModel: ListViewModel {
    ListViewModel(title: person.name, subtitle: ListViewModel.dateFormatter.string(from: person.dob))
  }
}
