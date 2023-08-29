//
//  HomeView.swift
//  Memory
//
//  Created by Carl Hung on 27/08/2023.
//

import SwiftUI

struct HomeView: View {
    
    @State
    private var searchText = ""
    
    @State
    var path: NavigationPath = NavigationPath()

    @StateObject
    var model: HomeViewModel
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                if let photos = model.photoStream?.photos.photo {
                    ScrollView {
                        Section {
                            LazyVGrid(columns: defaultColumns, spacing: 10) {
                                ForEach(
                                    photos,
                                    id: \.self
                                ) { photo in
                                    NavigationLink {
                                        PhotoDetailView(photo: photo)
                                    } label: {
                                        ThumbnailImageTagView(photo: photo) { photo in
                                            IconAndTitle(
                                                url: photo.profileIconURL,
                                                title: "NSID:\n\(photo.owner)",
                                                spacing: 2,
                                                iconLength: 25,
                                                fontSize: 13
                                            )
                                            .padding(
                                                EdgeInsets(
                                                    top: 2,
                                                    leading: 0,
                                                    bottom: 3,
                                                    trailing: 0
                                                )
                                            )
                                            if !photo.tags.isEmpty {
                                                Color(.black)
                                                    .frame(height: 2)
                                                Text("Tags:\n\(photo.tags)")
                                                    .font(.system(size: 13))
                                                    .defaultTextConfig()
                                                    .padding(5)
                                            }
                                        }
                                        .foregroundColor(.black)
                                        .defaultRoundedRectangle()
                                        .padding(.all, 5)
                                    }
                                    
                                }
                            }
                        } header: {
                            SearchBar(text: $searchText, path: $path, model: model) {
                                Task {
                                    try await model.getRecent()
                                }
                            }
                            .navigationDestination(for: String.self) { nsid in
                                PhotoStreamView(model: UserPublicPhotoStreamModel(nsid: nsid))
                            }
                            Color.black.frame(height: 2)
                        }
                    }
                    .refreshable {
                        self.searchText = ""
                        Task {
                            try await model.getRecent()
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    if model.photoStream == nil {
                        try await model.getRecent()
                    }
                }
            }
            .defaultNavigationBarConfig(barText: "Home View")
        }
    }
}

struct PHomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(model: HomeViewModel())
    }
}
