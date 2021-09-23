//
//  ImagePickerState.swift
//  ImagePicker
//
//  Created by Foggin, Oliver (Developer) on 22/09/2021.
//

import SwiftUI
import ComposableArchitecture
import PhotosUI

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
  }
}

public struct ImagePicker: UIViewControllerRepresentable {
  @Environment(\.presentationMode) var presentationMode
  
  let viewStore: ViewStore<ImagePickerState, ImagePickerAction>
  
  public init(store: Store<ImagePickerState, ImagePickerAction>) {
    self.viewStore = ViewStore(store)
  }
  
  public func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.delegate = context.coordinator
    return picker
  }
  
  public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
  }
  
  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let parent: ImagePicker
    
    init(_ parent: ImagePicker) {
      self.parent = parent
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      if let uiImage = info[.originalImage] as? UIImage {
        parent.viewStore.send(.imagePicked(image: uiImage))
      }
      
      parent.presentationMode.wrappedValue.dismiss()
    }
  }
}
