//
//  PhotoPicker.swift
//  SwiftUI-PHPicker
//
//  Created by Ikmal Azman on 30/03/2023.
//

import SwiftUI
import UIKit
import PhotosUI

struct PhotoPicker : UIViewControllerRepresentable {
    @Binding var selectedImages : [UIImage]
    @Environment(\.presentationMode) private var presentationMode
    
    /// `PHPickerViewController`: VC that allow to show UI for user to select media from the photo library
    func makeUIViewController(context: Context) -> PHPickerViewController {
        /// Create configuration for PHPickerViewController
        var configuration = PHPickerConfiguration()
        /// `selectionLimit`: allow to specify the number of item that user can select, specify 0 to enable unlimited selection
        configuration.selectionLimit = 4
        /// `filter`: allow to restrict on what kind of media that user can select
        configuration.filter = .images
        
        let pickerVC = PHPickerViewController(configuration: configuration)
        pickerVC.delegate = context.coordinator
        return pickerVC
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    /// `makeCoordinator()`: method allow to communicate UIKit VC delegate with SwiftUI. In this case, we provide the Coordinator object that have implementation for `PHPickerViewControllerDelegate`.
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
}

extension PhotoPicker {
    /// To adopt protocol in wrapper of specific UIKit VC,  we need to make a `Coordinator` object which acts as a bridge between the VC Delegate and SwiftUI. Then, we need to provide the `Coordinator` object to UIViewControllerRepresentable method  which is `makeCoordinator()` method.
    ///
    /// This `Coordinator` adopt protocol of `PHPickerViewControllerDelegate`.
    /// It also implement the method of  `PHPickerViewControllerDelegate` which is `picker(_ picker:, didFinishPicking:)` which will be call when media selected.
    final class Coordinator : NSObject, PHPickerViewControllerDelegate {
        var parent : PhotoPicker
        
        init(parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            /// Dismiss the photo library
            parent.presentationMode.wrappedValue.dismiss()
            
            /// Retrieve itemProvider from the result
            let itemProviders = results.map { result in
                /// `itemProvider`: allow to retrieve the presentation of selected assets
                result.itemProvider
            }
            
            /// Iterate all itemProviders and access the UIImage representation
            for itemProvider in itemProviders {
                handleImageSelection(from: itemProvider)
            }
        }
        
        func handleImageSelection(from itemProvider : NSItemProvider) {
            Task { @MainActor in
                let image = await loadObject(itemProvider)
                /// Assign the images to Parent of Coordinator
                self.parent.selectedImages.append(image)
            }
        }
        
        func loadObject(_ itemProvider : NSItemProvider) async -> UIImage {
            return await withCheckedContinuation { continuation in
                /// `canLoadObject(ofClass:)` : allow to validate whether an item provider can load objects of a given class
                guard itemProvider.canLoadObject(ofClass: UIImage.self) else {return}
                
                /// `loadObject(ofClass:)`: allow to load an object of a specified class to an item provider
                itemProvider.loadObject(ofClass: UIImage.self) { data, error in
                    
                    /// Access `NSItemProviderReading` and cast it into `UIImage` object
                    guard let data = data, let image = data as? UIImage else {return}
                    continuation.resume(returning: image)
                }
            }
        }
    }
}
