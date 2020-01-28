//
//  FlickrSearchPhotos.swift
//  FlickrGallery
//
//  Created by User on 28/01/2020.
//  Copyright © 2020 Muharrem Sonmez. All rights reserved.
//

import Foundation

struct FlickrSearchPhotos {
    let page: Int
    let pages: Int
    let perPage: Int
    let photos: [FlickrImage]
    let total: String
    
    
    init(page: Int, pages: Int, perPage: Int, photos: [FlickrImage], total: String) {
        self.page = page
        self.pages = pages
        self.perPage = perPage
        self.photos = photos
        self.total = total
    }
}

extension FlickrSearchPhotos: Decodable {
    enum ApiKeys: String, CodingKey {
        case page = "page"
        case pages = "pages"
        case perPage = "perpage"
        case photos = "photo"
        case total = "total"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ApiKeys.self)
        let page: Int = try container.decode(Int.self, forKey: .page)
        let pages: Int = try container.decode(Int.self, forKey: .pages)
        let perPage: Int = try container.decode(Int.self, forKey: .perPage)
        let photos: [FlickrImage] = try container.decode([FlickrImage].self, forKey: .photos)
        let total: String = try container.decode(String.self, forKey: .total)
        
        self.init(page: page, pages: pages, perPage: perPage, photos: photos, total: total)
    }
}
