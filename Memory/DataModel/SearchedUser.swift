//
//  SearchedUser.swift
//  Memory
//
//  Created by Carl Hung on 25/08/2023.
//

struct SearchedUser: Codable {
    let user: User?
    let stat: String
    let code: Int?
    let message: String?
}

// MARK: - User
struct User: Codable {
    let id, nsid: String
    let username: Username
}

// MARK: - Username
struct Username: Codable {
    let content: String

    enum CodingKeys: String, CodingKey {
        case content = "_content"
    }
}
