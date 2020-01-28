//
//  Flickr.swift
//  FlickrGallery
//
//  Created by User on 28/01/2020.
//  Copyright © 2020 Muharrem Sonmez. All rights reserved.
//

import UIKit

class Flickr {
    
    static let instance = Flickr() // Singleton
    
    let API_SEARCH_ENDPOINT = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&safe_search=1&text="
    
    func getImage(wihtSource source: FlickrImage, withCompletion completion:  @escaping (UIImage?, Error?) -> ()) {
        let API_IMAGE_ENDPOINT = "http://farm\(source.farm).static.flickr.com/\(source.server)/\(source.id)_\(source.secret).jpg"
        let imageURL = URL(string: API_IMAGE_ENDPOINT)
        DispatchQueue.global().async {
            do {
                let dataOfImage = try Data(contentsOf: imageURL!)
                let image = UIImage(data: dataOfImage)
                completion(image, nil)
            } catch {
                print("Error occurred while getting an image: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }
    
    func searchImages(withQuery query: String, withCompletion completion: @escaping (FlickrSearch?, Error?) -> ()) {
        let url = URL(string: "\(API_SEARCH_ENDPOINT)\(query)")
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "No images found for the query: \"\(query)\"", code: 0, userInfo: nil))
                return
            }
            
            do {
                print(data)
                let flickrResult: FlickrSearch = try JSONDecoder().decode(FlickrSearch.self, from: data)
                completion(flickrResult, nil)
            } catch {
                print("Error occured while searching images: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
        
        task.resume()
    }
    
}
