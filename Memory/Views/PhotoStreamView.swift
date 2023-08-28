//
//  PhotoStreamView.swift
//  Memory
//
//  Created by Carl Hung on 25/08/2023.
//

import SwiftUI

private let defaultGridItem = GridItem(.fixed(150), spacing: 30)

let defaultColumns = Array(repeating: defaultGridItem, count: 2)

struct PhotoStreamView: View {
    
    @StateObject
    var model: UserPublicPhotoStreamModel
    
    var body: some View {
        VStack(spacing: 0) {
            if let photoStreamResult = model.photoStream {
                switch photoStreamResult {
                case .failure(_):
                    Text("Failed to find the user")
                case .success(let photoStream):
                    let photos = photoStream.photos.photo
                    IconAndTitle(
                        url: getIconURLAndNSID.iconURL,
                        title: "NSID: \(getIconURLAndNSID.nsid)"
                    )
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    
                    Spacer()
                        .frame(height: 2)
                    Color(.black)
                        .frame(height: 2)
                    ScrollView {
                        Spacer().frame(height: 2)
                        LazyVGrid(columns: defaultColumns, alignment: .center, spacing: 10) {
                            ForEach(
                                photos,
                                id: \.self
                            ) { photo in
                                NavigationLink {
                                    PhotoDetailView(
                                        photo: photo
                                    )
                                } label: {
                                    ThumbnailImageTagView(photo: photo) { photo in
                                        if !photo.tags.isEmpty {
                                            Text("Tags:\n\(photo.tags)")
                                                .padding(.all, 5)
                                                .defaultTextConfig()
                                        }
                                    }
                                    .foregroundColor(.black)
                                    .defaultRoundedRectangle()
                                }
                            }
                        }
                    }
                    .refreshable {
                        Task {
                            await self.getPhotoStream()
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                if model.photoStream == nil {
                    await self.getPhotoStream()
                }
            }
        }
        .defaultNavigationBarConfig(barText: "Photo Stream")
    }
    
    var getIconURLAndNSID: (iconURL: URL?, nsid: String) {
        if let photoStream = model.photoStream,
           case let .success(photoStreamResult) = photoStream,
            let first = photoStreamResult.photos.photo.first {
            return (first.profileIconURL, first.owner)
        } else {
            return (model.defaultIcon, model.nsid)
        }
    }
    
    private func getPhotoStream() async {
        await model.getPhotoStream()
    }
}

struct PhotoStreamView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoStreamView(
            model: UserPublicPhotoStreamModel(
                nsid: "124055761@N02"
//                nsid: "48790596@N05"
//                nsid: "abcd"
            )
        )
    }
}
