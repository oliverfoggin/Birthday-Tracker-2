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
      df.dateStyle = .medium
      df.timeStyle = .none
      return df
    }
  }
  
  var listViewModel: ListViewModel {
    let age: () -> String = {
      let ageComps = Calendar.current.dateComponents([.year, .month, .day], from: person.dob, to: now())
      
      if ageComps.year! == 1 {
        return "One year old"
      } else if ageComps.year! > 1 {
        return "\(ageComps.year!) years old"
      } else if ageComps.month! == 1 {
        return "One month old"
      } else if ageComps.month! > 1 {
        return "\(ageComps.month!) months old"
      } else if ageComps.day! == 1 {
        return "One day old"
      } else if ageComps.day! > 1 {
        return "\(ageComps.day!) days old"
      } else {
        return "unknown age"
      }
    }
    
    return ListViewModel(
      title: person.name,
      subtitle: subtitle == .age ? age() : ListViewModel.dateFormatter.string(from: person.nextBirthday(now: now(), calendar: calendar))
    )
  }
}
