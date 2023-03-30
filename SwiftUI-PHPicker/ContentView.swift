//
//  ContentView.swift
//  SwiftUI-PHPicker
//
//  Created by Ikmal Azman on 30/03/2023.
//

import SwiftUI

struct ContentView: View {
    @State var image : Image = Image(systemName: "photo.artframe")
    
    var body: some View {
        
        VStack {
            Spacer()
            
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight:150)
            
            Spacer()
            
            Button {
                
            } label: {
                Label("Photo Library", image: "")
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
