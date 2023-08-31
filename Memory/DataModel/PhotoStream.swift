//
//  PhotoStream.swift
//  Memory
//
//  Created by Carl Hung on 25/08/2023.
//

import Foundation
import SwiftUI

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
    
    private enum FetchImageSize: String {
        case thumbnail = "_q",
             large = "_b"
    }
    
    private func imageURL(size: FetchImageSize) -> URL? {
        let id = self.id
        let secret = self.secret
        let server = self.server
        // https://www.flickr.com/services/api/misc.urls.html
        let urlHeadStr = "https://live.staticflickr.com/\(server)/\(id)_\(secret)"
        let jpgPrefix = ".jpg"
        let urlStr = urlHeadStr + size.rawValue + jpgPrefix
        return URL(string: urlStr)
    }
    
    var thumbnailURL: URL? {
        imageURL(size: .thumbnail)
    }
    
    var imageURL: URL? {
        imageURL(size: .large)
    }
    
    static var defaultIconURL: URL? {
        URL(string: "https://www.flickr.com/images/buddyicon.gif")
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
    
    var imageURL_QRcode: Image? {
        guard let imageURLstr = self.imageURL?.absoluteString else {
            return nil
        }
        return generateQRCode(from: imageURLstr)
    }
}
