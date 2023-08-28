//
//  PhotoStream.swift
//  Memory
//
//  Created by Carl Hung on 25/08/2023.
//

import Foundation

struct PhotoStream: Codable {
    let photos: Photos
    let stat: String
}

extension PhotoStream {
    struct Photos: Codable {
        let page, pages, perpage, total: Int
        let photo: [Photo]
    }

    struct Photo: Codable, Hashable {
        let id: String
        let owner: String
        let secret, server, iconserver: String
        let farm, iconfarm: Int
        let title: String
        let ispublic, isfriend, isfamily: Int
        let tags: String
        let datetaken: Date
        let ownername: String
        let description: Description
    }

    struct Description: Codable, Hashable {
        let content: String
        
        enum CodingKeys: String, CodingKey {
            case content = "_content"
        }
    }
}

extension PhotoStream.Photo {
    
    static var defaultIconURL: URL? {
        URL(string: "https://www.flickr.com/images/buddyicon.gif")
    }

    var imageURLs: (thumbnail: URL, original: URL)? {
        let id = self.id
        let secret = self.secret
        let server = self.server
        // https://www.flickr.com/services/api/misc.urls.html
        let urlHeadStr = "https://live.staticflickr.com/\(server)/\(id)_\(secret)"
        let jpgPrefix = ".jpg"
        let urlThumbnailStr = urlHeadStr + "_q" + jpgPrefix
        let urlOriginalImageStr = urlHeadStr + "_b" + jpgPrefix
        guard let thumbnailUrl = URL(string: urlThumbnailStr), let originalUrl = URL(string: urlOriginalImageStr) else {
            return nil
        }
        return (thumbnailUrl, originalUrl)
    }
    
    var profileIconURL: URL? {
        let iconfarm = self.iconfarm
        let iconserver = self.iconserver
        let nsid = self.owner
        // https://www.flickr.com/services/api/misc.buddyicons.html
        if iconfarm != 0,
            iconserver != "0",
            let iconURL = URL(string: "https://farm\(iconfarm).staticflickr.com/\(iconserver)/buddyicons/\(nsid).jpg") {
            return iconURL
        } else {
            return Self.defaultIconURL
        }
    }
}
