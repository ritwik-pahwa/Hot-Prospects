//
//  MeView.swift
//  Hot Prospects
//
//  Created by Ritwik Pahwa on 15/07/22.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct MeView: View {
    
    @State private var name = "Ritwik Pahwa"
    @State private var email = "email@gmail.com"
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        Form{
            TextField("Name", text: $name)
                .textContentType(.name)
                .font(.title)
            
            TextField("email", text: $email)
                .textContentType(.emailAddress)
                .font(.title)
            
            
            Image(uiImage: generateQRCode("\(name)\n\(email)"))
                .resizable()
                .interpolation(.none)
                .scaledToFit()
                .frame(width: 200, height: 200)
        }
        .navigationTitle("Me")
    }
    
    
    func generateQRCode(_ string: String) -> UIImage {
        
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgImg = context.createCGImage(outputImage, from: outputImage.extent){
                return UIImage(cgImage: cgImg)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}


struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}
