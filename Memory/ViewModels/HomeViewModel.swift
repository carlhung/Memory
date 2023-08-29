//
//  HomeViewModel.swift
//  Memory
//
//  Created by Carl Hung on 27/08/2023.
//

import SwiftUI

final class HomeViewModel: ObservableObject, Model {
    
    @Published
    var photoStream: PhotoStream?
    
    @MainActor
    func getRecent() async throws {
        self.photoStream = try await api.getRecent()
    }
    
    func searchUser(name: String) async throws -> String? {
        let searchUserResult = try await api.findBy(username: name)
        return searchUserResult.user?.nsid
    }
    
    @MainActor
    func searchTaggedPhotos(tags: String) async throws {
        self.photoStream = try await api.search(tags: tags)
    }
}
