//
//  IconAndTitle.swift
//  Memory
//
//  Created by Carl Hung on 27/08/2023.
//

import SwiftUI

struct IconAndTitle: View {
    
    let url: URL?
    let title: String
    var spacing: CGFloat = 10
    var iconLength: CGFloat = 50
    var fontSize: CGFloat = 20
    
    var body: some View {
        HStack(alignment: .center, spacing: spacing) {
            AsyncImageHack(url: url) { phase in
                if case let .success(image) = phase {
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .frame(width: iconLength, height: iconLength, alignment: .center)
            .clipShape(Circle())
            Text(title)
                .font(.system(size: fontSize))
                .foregroundColor(.black)
                .defaultTextConfig()
        }
    }
}

