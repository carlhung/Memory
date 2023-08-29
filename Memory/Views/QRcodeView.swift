//
//  QRcodeView.swift
//  Memory
//
//  Created by Carl Hung on 29/08/2023.
//

import SwiftUI

struct QRcodeView: View {
    
    @Binding var shown: Bool

    var qrCodeImage: Image
    
    let width = UIScreen.main.bounds.width/2-30
    
    var body: some View {
        VStack {
            Spacer()
            qrCodeImage
                .resizable()
                .frame(width: width, height: width)
            Spacer()
            Divider()
            HStack {
                Button("OK") {
                    shown.toggle()
                }
                .font(.system(size: 20, weight: .heavy, design: .default))
                .frame(width: width, height: 40)
                .foregroundColor(.white)
            }
            Divider()
        }
        .frame(width: UIScreen.main.bounds.width-50, height: 250)
        
        .background(Color.black.opacity(0.5))
        .cornerRadius(12)
        .clipped()
        
    }
}
