//
//  Helpers.swift
//  Memory
//
//  Created by Carl Hung on 29/08/2023.
//

import Foundation
import UIKit
import SwiftUI

func generateQRCode(from string: String) -> Image? {
    guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
    let data = string.data(using: .ascii, allowLossyConversion: false)
    filter.setValue(data, forKey: "inputMessage")
    guard let ciimage = filter.outputImage else { return nil }
    let transform = CGAffineTransform(scaleX: 10, y: 10)
    let scaledCIImage = ciimage.transformed(by: transform)
    let uiimage = UIImage(ciImage: scaledCIImage)
    guard let pngData = uiimage.pngData(),
            let uiImg = UIImage(data: pngData) else {
        return nil
    }
    return Image(uiImage: uiImg)
}

func generateProfileURL(nsid: String) -> URL? {
    let baseURL = "https://www.flickr.com/photos/"
    return URL(string: baseURL + nsid + "/")
}
