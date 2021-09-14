import Foundation
import ComposableArchitecture
import Common

public struct FileClient {
  struct Failure: Error, Equatable {
    let message: String?
  }
  
  public var save: (_ data: [Person], _ fileName: String) -> Effect<Never, Never>
  public var load: (_ fileName: String) -> Effect<[Person], Never>
}

public extension FileClient {
  static var live = Self.init(
    save: { data, fileName in
      if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let urlPath = directory.appendingPathComponent(fileName)

        do {
          let jsonObject = try JSONEncoder().encode(data)
          try jsonObject.write(to: urlPath)
        } catch {
          // Handle error
        }
      }
      
      return .none
    },
    load: { fileName in
      if let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let urlPath = directory.appendingPathComponent(fileName)

        do {
          let data = try Data(contentsOf: urlPath)
          let object = try JSONDecoder().decode([Person].self, from: data)
          return Effect(value: object)
        } catch {
          // Handle error
        }
      }
      
      return Effect(value: [])
    }
  )
}
