//
//  ImageCache.swift
//  FlickrGallery
//
//  Created by User on 28/01/2020.
//  Copyright © 2020 Muharrem Sonmez. All rights reserved.
//

import UIKit

class ImageCache {
    
    static let instance = ImageCache()
    
    private var images: [String:CachedImage] = [:]
    private let palceholderImage = UIImage(systemName: "camera.on.rectangle.fill")
    private var subscribers: [String:Subscriber] = [:]
    
    private func add(image: UIImage, forKey key:String) {
        if var cached = images[key] {
            cached.image = image
            cached.status = .Completed
            images[key] = cached
        } else {
            images[key] = CachedImage(status: .Completed, image: image)
        }
    }
    
    private func fail(forSource source: FlickrImage) {
        images[source.getKey()] = CachedImage(status: .Failed, image: nil)
    }
    
    private func start(forSource source: FlickrImage, withSubscriber subscriber: Subscriber) {
        images[source.getKey()] = CachedImage(status: .InProgress, image: nil)
        subscribers[source.getKey()] = subscriber
        Flickr.instance.getImage(wihtSource: source, withCompletion: { (image, error) in
            guard error == nil else {
                self.subscribers[source.getKey()]?.update(withImage: self.palceholderImage)
                self.fail(forSource: source)
                return
            }
            self.add(image: image!, forKey: source.getKey())
            self.subscribers[source.getKey()]?.update(withImage: image)
        })
    }
    
    func image(forSource source:FlickrImage, withSubscriber subscriber: Subscriber) {
        subscriber.update(withImage: self.palceholderImage)
        if let cached = images[source.getKey()] {
            switch cached.status {
                case .Completed:
                    subscriber.update(withImage: cached.image)
                    break
                case .Failed:
                    subscriber.update(withImage: self.palceholderImage)
                    break
                case .InProgress:
                    self.subscribers[source.getKey()] = subscriber
            }
        } else {
            self.start(forSource: source, withSubscriber: subscriber)
        }
    }
}
