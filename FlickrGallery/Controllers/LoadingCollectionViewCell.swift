//
//  LoadingCollectionReusableView.swift
//  FlickrGallery
//
//  Created by User on 28/01/2020.
//  Copyright © 2020 Muharrem Sonmez. All rights reserved.
//

import UIKit

class LoadingCollectionReusableView: UICollectionReusableView {
    
    // IBOutlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
}
