//
//  CachedImage.swift
//  FlickrGallery
//
//  Created by User on 28/01/2020.
//  Copyright © 2020 Muharrem Sonmez. All rights reserved.
//

import UIKit

enum ImageStatus {
    case InProgress
    case Completed
    case Failed
}

struct CachedImage {
    var status: ImageStatus
    var image: UIImage?
}
