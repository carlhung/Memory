//
//  QRcodeView.swift
//  Memory
//
//  Created by Carl Hung on 29/08/2023.
//

import SwiftUI

protocol QRCodeViewProtocol {
    var shown: Binding<Bool> { get set }
    var qrCodeImage: Image? { get }
    @MainActor
    var width: Double { get }
}

extension QRCodeViewProtocol {
    
    @MainActor
    var width: Double { UIScreen.main.bounds.width / Double(2 - 30) }
}

struct QRcodeView: QRCodeViewProtocol {
    var shown: Binding<Bool>
    var qrCodeImage: Image?
}

extension QRCodeViewProtocol where Self: View {
    
    @MainActor
    @ViewBuilder
    var body: some View {
        vstack {
            content
        }
        .frame(width: UIScreen.main.bounds.width - 50, height: 250)
        
        .background(Color.black.opacity(0.5))
        .cornerRadius(12)
        .clipped()
    }
    
    @MainActor
    @ViewBuilder
    private var content: some View {
        Spacer()
        qrCodeImage?
            .resizable()
            .frame(width: width, height: width)
        Spacer()
        Divider()
        HStack {
            Button("OK") {
                shown.wrappedValue.toggle()
            }
            .font(.system(size: 20, weight: .heavy, design: .default))
            .frame(width: width, height: 40)
            .foregroundColor(.white)
        }
        Divider()
    }
    
    private func vstack(@ViewBuilder block: () -> some View) -> VStack<some View> {
        VStack{
            block()
        }
    }
}

extension QRcodeView: View {}

//struct QRcodeView: View {
//    
//    @Binding
//    var shown: Bool
//
//    let qrCodeImage: Image?
//    
//    let width = UIScreen.main.bounds.width / 2 - 30
//    
//    var body: some View {
//        VStack {
//            Spacer()
//            qrCodeImage?
//                .resizable()
//                .frame(width: width, height: width)
//            Spacer()
//            Divider()
//            HStack {
//                Button("OK") {
//                    shown.toggle()
//                }
//                .font(.system(size: 20, weight: .heavy, design: .default))
//                .frame(width: width, height: 40)
//                .foregroundColor(.white)
//            }
//            Divider()
//        }
//        .frame(width: UIScreen.main.bounds.width - 50, height: 250)
//        
//        .background(Color.black.opacity(0.5))
//        .cornerRadius(12)
//        .clipped()
//    }
//}
