//
//  FlickrImage.swift
//  FlickrGallery
//
//  Created by User on 28/01/2020.
//  Copyright © 2020 Muharrem Sonmez. All rights reserved.
//

import UIKit

struct FlickrImage {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let farm: Int
    let title: String
    let isPublic: Bool
    let isFriend: Bool
    let isFamily: Bool
    
    init(id: String, owner: String, secret: String, server: String, farm: Int, title: String, isPublic: Bool, isFriend: Bool, isFamily: Bool) {
        self.id = id
        self.owner = owner
        self.secret = secret
        self.server = server
        self.farm = farm
        self.title = title
        self.isPublic = isPublic
        self.isFriend = isFriend
        self.isFamily = isFamily
    }
    
    func getKey() -> String {
        return "\(id)-\(owner)-\(secret)-\(server)-\(farm)"
    }
}

extension FlickrImage: Decodable {
    enum ApiKeys: String, CodingKey {
        case id = "id"
        case owner = "owner"
        case secret = "secret"
        case server = "server"
        case farm = "farm"
        case title = "title"
        case isPublic = "ispublic"
        case isFriend = "isfriend"
        case isFamily = "isfamily"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ApiKeys.self)
        let id: String = try container.decode(String.self, forKey: .id)
        let owner: String = try container.decode(String.self, forKey: .owner)
        let secret: String = try container.decode(String.self, forKey: .secret)
        let server: String = try container.decode(String.self, forKey: .server)
        let farm: Int = try container.decode(Int.self, forKey: .farm)
        let title: String = try container.decode(String.self, forKey: .title)
        let isPublic: Bool = try container.decode(Int.self, forKey: .isPublic) == 1 ? true : false
        let isFriend: Bool = try container.decode(Int.self, forKey: .isFriend) == 1 ? true : false
        let isFamily: Bool = try container.decode(Int.self, forKey: .isFamily) == 1 ? true : false
        
        self.init(id: id, owner: owner, secret: secret, server: server, farm: farm, title: title, isPublic: isPublic, isFriend: isFriend, isFamily: isFamily)
    }
}
