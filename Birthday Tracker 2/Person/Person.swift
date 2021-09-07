//
//  Person.swift
//  Person
//
//  Created by Foggin, Oliver (Developer) on 07/09/2021.
//

import Foundation

struct Person: Equatable, Identifiable {
  var id: UUID
  var name: String
  var dob: Date
}
