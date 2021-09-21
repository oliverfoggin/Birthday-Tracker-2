import Foundation
import ComposableArchitecture
import Common

public struct FileClient {
  struct Failure: Error, Equatable {
    let message: String?
  }
  
  var save: (_ data: [Person], _ fileName: String) -> Effect<Never, Never>
  var load: (_ fileName: String) -> Effect<[Person], Never>
  
  public init(save: @escaping ([Person], String) -> Effect<Never, Never>, load: @escaping (String) -> Effect<[Person], Never>) {
    self.save = save
    self.load = load
  }
}

extension FileClient {
  static var live = Self.init(
    save: { data, fileName in
      let storeURL = AppGroup.birthdayTracker.containerURL.appendingPathComponent(fileName)
      
      do {
        let jsonObject = try JSONEncoder().encode(data)
        try jsonObject.write(to: storeURL)
      } catch {
        // Handle error
      }
      
      return .none
    },
    load: { fileName in
      let storeURL = AppGroup.birthdayTracker.containerURL.appendingPathComponent(fileName)
    
      do {
        let data = try Data(contentsOf: storeURL)
        let object = try JSONDecoder().decode([Person].self, from: data)
        return Effect(value: object)
      } catch {
        return Effect(value: [])
      }
    }
  )
}
