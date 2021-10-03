//
//  GiftIdea.swift
//  Common
//
//  Created by Foggin, Oliver (Developer) on 03/10/2021.
//

import Foundation

extension Person {
  public struct GiftIdea: Equatable, Identifiable {
    public var id: UUID
    public var name: String = ""
    public var favourite: Bool = false
    public var bought: Bool = false
    public var notes: String = ""
    
    public init(id: UUID) {
      self.id = id
    }
  }
}

extension Person.GiftIdea: Codable {
  enum CodingKeys: String, CodingKey {
    case id, name, favourite, bought, notes
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    id = try container.decode(UUID.self, forKey: .id)
    name = try container.decode(String.self, forKey: .name)
    favourite = try container.decode(Bool.self, forKey: .favourite)
    bought = try container.decode(Bool.self, forKey: .bought)
    notes = (try? container.decode(String.self, forKey: .notes)) ?? ""
  }
}
