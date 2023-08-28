//
//  DataExten.swift
//  Memory
//
//  Created by Carl Hung on 25/08/2023.
//

import Foundation

public extension Data {
    func decodeJSON<T: Decodable>(_ type: T.Type = T.self,
                                decodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
                                dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                                dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .base64) throws -> T {
        let decoder = JSONDecoder()

        switch decodingStrategy {
        case .useDefaultKeys: break
        default: decoder.keyDecodingStrategy = decodingStrategy
        }

        switch dateDecodingStrategy {
        case .deferredToDate: break
        default: decoder.dateDecodingStrategy = dateDecodingStrategy
        }

        switch dataDecodingStrategy {
        case .base64: break
        default: decoder.dataDecodingStrategy = dataDecodingStrategy
        }
        return try decoder.decode(T.self, from: self)
    }
}
