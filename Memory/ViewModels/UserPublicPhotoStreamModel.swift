//
//  UserPublicPhotoStreamModel.swift
//  Memory
//
//  Created by Carl Hung on 25/08/2023.
//

import Foundation

final class UserPublicPhotoStreamModel: ObservableObject, Model {
    
    let nsid: String
    
    @Published
    var photoStream: Result<PhotoStream, any Error>?
    
    init(nsid: String) {
        self.nsid = nsid
    }
    
    @MainActor
    func getPhotoStream() async {
        do {
            self.photoStream = try await .success(api.getPublicPhotos(nsid: nsid))
        } catch {
            self.photoStream = .failure(error)
        }
    }
    
    var defaultIcon: URL? {
        PhotoStream.Photo.defaultIconURL
    }
}
