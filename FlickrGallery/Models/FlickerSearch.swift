//
//  FlickerSearch.swift
//  FlickrGallery
//
//  Created by User on 28/01/2020.
//  Copyright © 2020 Muharrem Sonmez. All rights reserved.
//

import Foundation

struct FlickrSearch {
    let photos: FlickrSearchPhotos
    let status: String
    
    init(photos: FlickrSearchPhotos, status: String) {
        self.photos = photos
        self.status = status
    }
}

extension FlickrSearch: Decodable {
    enum ApiKeys: String, CodingKey {
        case photos = "photos"
        case status = "stat"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ApiKeys.self)
        let photos: FlickrSearchPhotos = try container.decode(FlickrSearchPhotos.self, forKey: .photos)
        let status: String = try container.decode(String.self, forKey: .status)
        
        self.init(photos: photos, status: status)
    }
}
