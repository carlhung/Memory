//
//  PhotoDetailView.swift
//  Memory
//
//  Created by Carl Hung on 27/08/2023.
//

import SwiftUI

struct PhotoDetailView: View {
    
    let photo: PhotoStream.Photo
    
    let dateFormatter: DateFormatter = {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    @State
    var showProfileUrlQR = false
    
    @State
    var showImageUrlQR = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 10) {
                    AsyncImageHack(url: photo.imageURL) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } else if let err = phase.error {
                            Text("Error:\n\(err.localizedDescription)")
                        } else {
                            Color.gray
                        }
                    }
                    NavigationLink {
                        PhotoStreamView(
                            model: UserPublicPhotoStreamModel(
                                nsid: photo.owner
                            )
                        )
                    } label: {
                        IconAndTitle(
                            url: photo.profileIconURL,
                            title: "NSID: \(photo.owner)",
                            spacing: 15,
                            iconLength: 50,
                            fontSize: 20
                        )
                        .padding(
                            EdgeInsets(
                                top: 10,
                                leading: 20,
                                bottom: 10,
                                trailing: 20
                            )
                        )
                        .defaultRoundedRectangle(.gray)
                        .padding(
                            EdgeInsets(
                                top: 0,
                                leading: 20,
                                bottom: 0,
                                trailing: 20
                            )
                        )
                    }
                    
                    if !photo.title.isEmpty {
                        LeadingText("""
                         Title:
                         \(photo.title)
                         """)
                    }
                    LeadingText("""
                     Username:
                     \(photo.ownername)
                     """)
                    LeadingText("""
                     Taken Date:
                     \(dateFormatter.string(from: photo.datetaken))
                     """)
                    if !photo.description.content.isEmpty {
                        LeadingText("""
                         Description:
                         \(photo.description.content)
                         """)
                    }
                }
            }
            
            if showImageUrlQR {
                QRcodeView(shown: $showImageUrlQR, qrCodeImage: photo.imageURL_QRcode)
            }
            
            if showProfileUrlQR {
                if let url = generateProfileURL(nsid: photo.owner) {
                    QRcodeView(shown: $showProfileUrlQR, qrCodeImage: generateQRCode(from: url.absoluteString))
                } else {
                    QRcodeView(shown: $showProfileUrlQR, qrCodeImage: nil)
                }
            }
        }
        .defaultNavigationBarConfig(barText: "Photo Detail")
        .toolbar {
            ToolbarItem {
                Menu("GR Code") {
                    Button("User Profile URL") {
                        showProfileUrlQR = true
                    }
                    Button("Image URL") {
                        showImageUrlQR = true
                    }
                }
            }
        }
    }
}

private struct LeadingText: View {
    let context: String
    let font: Font?
    
    init(_ context: String, font: Font? = nil) {
        self.context = context
        self.font = font
    }
    
    var body: some View {
        Text(context)
            .font(font)
            .defaultTextConfig()
            .padding(
                EdgeInsets(
                    top: 0,
                    leading: 10,
                    bottom: 0,
                    trailing: 10)
            )
    }
}
