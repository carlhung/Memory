//
//  AsyncImageHack.swift
//  Memory
//
//  Created by Carl Hung on 27/08/2023.
//

import SwiftUI

// There is a bug in AsyncImage, https://stackoverflow.com/questions/73179886/asyncimage-not-rendering-all-images-in-a-list-and-producing-error-code-999-ca
// workaround, https://developer.apple.com/forums/thread/682498
struct AsyncImageHack<Content: View>: View {

    let url: URL?
    
    @ViewBuilder
    let content: (AsyncImagePhase) -> Content

    @State private var currentUrl: URL?
    
    var body: some View {
        AsyncImage(url: currentUrl, content: content)
        .onAppear {
            if currentUrl == nil {
                Task {
                    currentUrl = url
                }
            }
        }
    }
}
