//
//  HomeViewModel.swift
//  Memory
//
//  Created by Carl Hung on 27/08/2023.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject, Model {
    
    @Published
    var photoStream: PhotoStream?
    
    func getRecent() async throws {
        self.photoStream = try await api.getRecent()
    }
}

extension HomeViewModel: SearchBarModel {
    func searchUser(name: String) async throws -> String? {
        let searchUserResult = try await api.findBy(username: name)
        return searchUserResult.user?.nsid
    }
    
    func searchTaggedPhotos(tags: String) async throws {
        self.photoStream = try await api.search(tags: tags)
    }
}

/// another way
/*
 final class HomeViewModel: ObservableObject, Model, @unchecked Sendable {
     
     @MainActor
     @Published
     var photoStream: PhotoStream?
     
     func getRecent() async throws {
         Task.detached { @MainActor in
             self.photoStream = try await self.api.getRecent()
         }
     }
 }

 extension HomeViewModel: SearchBarModel {
     func searchUser(name: String) async throws -> String? {
         let searchUserResult = try await api.findBy(username: name)
         return searchUserResult.user?.nsid
     }
     
     func searchTaggedPhotos(tags: String) async throws {
         Task.detached { @MainActor in
             self.photoStream = try await self.api.search(tags: tags)
         }
     }
 }
 */
