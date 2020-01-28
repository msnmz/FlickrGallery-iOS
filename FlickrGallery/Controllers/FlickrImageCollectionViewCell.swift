//
//  FlickrImageCollectionViewCell.swift
//  FlickrGallery
//
//  Created by User on 28/01/2020.
//  Copyright © 2020 Muharrem Sonmez. All rights reserved.
//

import UIKit

class FlickrImageCollectionViewCell: UICollectionViewCell {
    
    // IBOutlets
    @IBOutlet weak var flickrImageView: UIImageView?
    
    // Models
    var flickrSource: FlickrImage? {
        didSet {
            ImageCache.instance.image(forSource: flickrSource!, withSubscriber: self)
        }
    }
    
    // Adds Corner radius
    override func awakeFromNib() {
        flickrImageView?.layer.cornerRadius = 10
        flickrImageView?.layer.masksToBounds = true
        super.awakeFromNib()
    }
}

extension FlickrImageCollectionViewCell: Subscriber {
    func update(withImage image: UIImage?) {
        DispatchQueue.main.async {
            self.flickrImageView?.image = image
        }
    }
}

