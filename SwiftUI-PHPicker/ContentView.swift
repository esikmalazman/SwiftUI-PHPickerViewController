//
//  ContentView.swift
//  SwiftUI-PHPicker
//
//  Created by Ikmal Azman on 30/03/2023.
//

import SwiftUI

struct ContentView: View {
    @State var shouldShowPhotoPicker : Bool = false
    @State var selectedImages = [UIImage]()
    
    var body: some View {
        VStack {
            if selectedImages.isEmpty {
                placeholderImage
            } else {
                selectedImage
            }
            
            photosLibraryButton
                .padding(.top)
        }
        .padding()
        .sheet(isPresented: $shouldShowPhotoPicker) {
            PhotoPicker(selectedImages: $selectedImages)
        }
    }
    
    var placeholderImage : some View {
        Image(systemName: "photo.artframe")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight:150)
    }
    
    var selectedImage : some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(selectedImages, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 150, maxHeight: 150)
                }
            }
        }
    }
    
    var photosLibraryButton : some View {
        Button {
            shouldShowPhotoPicker.toggle()
        } label: {
            Label("Photo Library", image: "")
                .padding()
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
