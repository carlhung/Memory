//
//  Model.swift
//  Memory
//
//  Created by Carl Hung on 27/08/2023.
//

protocol Model {
    associatedtype APISocket: API
    var api: APISocket { get }
}

extension Model {
    var api: Connector {
        Connector.shared
    }
}
