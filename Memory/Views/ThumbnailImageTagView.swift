//
//  ThumbnailImageTagView.swift
//  Memory
//
//  Created by Carl Hung on 27/08/2023.
//

import SwiftUI

struct ThumbnailImageTagView<Content: View>: View {
    
    // https://www.flickr.com/services/api/misc.urls.html
    // The thumbnail we are using here is 150px with suffix `q`.
    
    let photo: PhotoStream.Photo
    var length = 150.0
    
    @ViewBuilder
    let content: (PhotoStream.Photo) -> Content
    
    var body: some View {
        VStack(spacing: 0) {
            AsyncImageHack(url: photo.thumbnailURL) { phase in
                if let image = phase.image {
                    image // Displays the loaded image.
                } else if phase.error != nil {
                    Text("Failed to load")
                } else {
                    Color.gray
                }
            }.frame(
                width: length,
                height: length
            )
            content(photo)
        }
    }
}
