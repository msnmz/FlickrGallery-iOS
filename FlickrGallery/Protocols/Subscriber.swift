//
//  Subscriber.swift
//  FlickrGallery
//
//  Created by User on 28/01/2020.
//  Copyright © 2020 Muharrem Sonmez. All rights reserved.
//

import UIKit

protocol Subscriber {
    func update(withImage image: UIImage?)
}
