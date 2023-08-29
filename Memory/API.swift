//
//  API.swift
//  Memory
//
//  Created by Carl Hung on 25/08/2023.
//

import Foundation

final class API {

    static let shared = API()

    enum APIError: Error {
        case urlConstructError(ErrorLogInformation)
        case nonHttpResponse(ErrorLogInformation)
        case non200StatusCode(ErrorLogInformation)
    }

    private static let api_key = "727859688011532b3ec61d710d88aa15"

    static var endpoint: URLComponents = {
        var component = URLComponents()
        component.scheme = "https"
        component.host = "api.flickr.com"
        component.path = "/services/rest/"
        return component
    }()
    
    private static let takenDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        // https://www.flickr.com/services/api/misc.dates.html
        // The date taken should always be displayed in the timezone of the photo owner, which is to say, don't perform any conversion on it.
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    private static func createGetRequest(queries: [String: String], errorLogInformation: ErrorLogInformation) throws -> URL {
        var endpointComponent = endpoint
        endpointComponent.queryItems = queries.map { URLQueryItem(name: $0.0, value: $0.1) }
        guard let url = endpointComponent.url else {
            throw APIError.urlConstructError(errorLogInformation)
        }
        return url
    }
    
    private static func addCommonQueries(queriesDict: inout [String: String]) {
        queriesDict["api_key"] = Self.api_key
        queriesDict["format"] = "json"
        queriesDict["nojsoncallback"] = "1"
    }
    
    private static let defaultExtraAndPerPage = ["extras": "tags, description, date_taken, owner_name, icon_server", "per_page": "500"]
    
    /// Get a list of public PhotoStream for the given `nsid`.
    func getPublicPhotos(nsid: String) async throws -> PhotoStream {
        // https://www.flickr.com/services/api/flickr.people.getPublicPhotos.html
        var queriesDict = Self.defaultExtraAndPerPage
        queriesDict["user_id"] = nsid
        return try await Self.requestWithTakenDateDecodingStrategy(method: "flickr.people.getPublicPhotos", queriesDict: queriesDict)
    }
    
    func getRecent() async throws -> PhotoStream {
        // https://www.flickr.com/services/api/flickr.photos.getRecent.htm
        let queriesDict = Self.defaultExtraAndPerPage
        return try await Self.requestWithTakenDateDecodingStrategy(method: "flickr.photos.getRecent", queriesDict: queriesDict)
    }
    
    func search(tags: String) async throws -> PhotoStream {
        // https://www.flickr.com/services/api/flickr.photos.search.html
        var queriesDict = Self.defaultExtraAndPerPage
        queriesDict["tags"] = tags
        queriesDict["tag_mode"] = "all"
        return try await Self.requestWithTakenDateDecodingStrategy(method: "flickr.photos.search", queriesDict: queriesDict)
    }
    
    func findBy(username: String) async throws -> SearchedUser {
        // https://www.flickr.com/services/api/flickr.people.findByUsername.htm
        let queriesDict = ["username": username]
        return try await Self.request(method: "flickr.people.findByUsername", queriesDict: queriesDict)
    }
    
    private static func request<T: Decodable>(
        method: String,
        queriesDict: [String: String],
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = nil,
        errorLogInformation: ErrorLogInformation = ErrorLogInformation()
    ) async throws -> T {
        var queriesDict = queriesDict
        queriesDict["method"] = method
        Self.addCommonQueries(queriesDict: &queriesDict)
        let url = try Self.createGetRequest(queries: queriesDict, errorLogInformation: errorLogInformation)
        let (data, urlResponse) = try await URLSession.shared.data(from: url)
        try checkIfStatusCodeCorrect(urlResponse: urlResponse, errorLogInformation: errorLogInformation)
        if let dateDecodingStrategy {
            return try data.decodeJSON(T.self, dateDecodingStrategy: dateDecodingStrategy)
        } else {
            return try data.decodeJSON(T.self)
        }
    }
    
    private static func requestWithTakenDateDecodingStrategy<T: Decodable>(
        method: String,
        queriesDict: [String: String],
        errorLogInformation: ErrorLogInformation = ErrorLogInformation()
    ) async throws -> T {
        try await request(
            method: method,
            queriesDict: queriesDict,
            dateDecodingStrategy: .formatted(Self.takenDateFormatter),
            errorLogInformation: errorLogInformation
        )
    }

    private static func checkIfStatusCodeCorrect(urlResponse: URLResponse, errorLogInformation: ErrorLogInformation) throws {
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            throw APIError.nonHttpResponse(errorLogInformation)
        }
        guard httpResponse.statusCode == 200 else {
            var errorLogInformation = errorLogInformation
            errorLogInformation.message = "state code: \(httpResponse.statusCode)"
            throw APIError.non200StatusCode(errorLogInformation)
        }
    }
}
