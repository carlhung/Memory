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
    let data = string.data(using: String.Encoding.ascii)

    if let filter = CIFilter(name: "CIQRCodeGenerator") {
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 3, y: 3)
        
        if let output = filter.outputImage?.transformed(by: transform) {
            let uiImg = UIImage(ciImage: output)
            return Image(uiImage: uiImg)
        }
    }

    return nil
}

func generateProfileURL(nsid: String) -> URL? {
    let baseURL = "https://www.flickr.com/photos/"
    return URL(string: baseURL + nsid)
}
