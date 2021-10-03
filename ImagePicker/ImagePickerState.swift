//
//  ImagePickerState.swift
//  ImagePicker
//
//  Created by Foggin, Oliver (Developer) on 22/09/2021.
//

import SwiftUI
import ComposableArchitecture
import PhotosUI

import Combine

extension PHPickerResult {
  public struct ImageError: Error {
    let message: String
  }
  
  func loadImage() -> Future<UIImage, ImageError> {
    return Future() { promise in
      guard case let itemProvider = self.itemProvider,
        itemProvider.canLoadObject(ofClass: UIImage.self) else {
          promise(.failure(ImageError(message: "Unable to load image.")))
          return
        }
      
      itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
        guard let image = image as? UIImage else {
          promise(.failure(ImageError(message: "Asset is not an image.")))
          return
        }
        promise(.success(image))
      }
    }
  }
}

public struct ImagePickerState: Equatable {
  public var showingImagePicker: Bool
  public var image: UIImage?
  
  public init(showingImagePicker: Bool, image: UIImage? = nil) {
    self.showingImagePicker = showingImagePicker
    self.image = image
  }
}

public enum ImagePickerAction {
  case setSheet(isPresented: Bool)
  
  case imagePicked(image: UIImage)
  
  case pickerResultReceived(result: PHPickerResult)
  case picked(result: Result<UIImage, PHPickerResult.ImageError>)
}

public struct ImagePickerEnvironment {
  public init() {}
}

public let imagePickerReducer = Reducer<ImagePickerState, ImagePickerAction, ImagePickerEnvironment> {
  state, action, environment in
  
  switch action {
  case let .setSheet(isPresented: presented):
    state.showingImagePicker = presented
    return .none
    
  case let .imagePicked(image: image):
    state.image = image
    return .none
    
  case let .pickerResultReceived(result: result):
    return result.loadImage()
      .receive(on: DispatchQueue.main)
      .catchToEffect(ImagePickerAction.picked(result:))
    
  case let .picked(result: .success(image)):
    state.image = image
    return .none
    
  case .picked(result: .failure):
    return .none
  }
}

public struct ImagePicker: UIViewControllerRepresentable {
  @Environment(\.presentationMode) var presentationMode

  let viewStore: ViewStore<ImagePickerState, ImagePickerAction>

  public init(store: Store<ImagePickerState, ImagePickerAction>) {
    self.viewStore = ViewStore(store)
  }

  public func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> some UIViewController {
    var config = PHPickerConfiguration()
    config.filter = PHPickerFilter.images
    config.selectionLimit = 1

    let picker = PHPickerViewController(configuration: config)
    picker.delegate = context.coordinator
    return picker
  }

  public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  public class Coordinator: PHPickerViewControllerDelegate {
    let parent: ImagePicker

    init(_ parent: ImagePicker) {
      self.parent = parent
    }

    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      parent.presentationMode.wrappedValue.dismiss()

      guard let result = results.first else {
        parent.viewStore.send(.picked(result: .failure(.init(message: "No image picked."))))
        return
      }
      
      parent.viewStore.send(.pickerResultReceived(result: result))
    }
  }
}
