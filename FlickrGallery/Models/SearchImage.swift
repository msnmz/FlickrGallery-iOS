//
//  SearchImage.swift
//  FlickrGallery
//
//  Created by User on 28/01/2020.
//  Copyright © 2020 Muharrem Sonmez. All rights reserved.
//

import UIKit

class SearchImage {
    let flickrImage: FlickrImage
    var image: UIImage?
    
    init(withFlickrImage flickrImage: FlickrImage) {
        self.flickrImage = flickrImage
        Flickr.instance.getImage(wihtSource: flickrImage, withCompletion: { (image, error) in
            guard error == nil else {
                return
            }
            
            self.image = image
        })
    }
}
