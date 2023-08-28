//
//  Model.swift
//  Memory
//
//  Created by Carl Hung on 27/08/2023.
//

protocol Model {
    var api: API { get }
}

extension Model {
    var api: API {
        API.shared
    }
}
