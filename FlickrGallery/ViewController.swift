//
//  ViewController.swift
//  FlickrGallery
//
//  Created by User on 28/01/2020.
//  Copyright © 2020 Muharrem Sonmez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    
    // Variables
    var images: [FlickrImage] = []
    var isLoading = false
    var page = 1
    var query = ""
    var loaingView: LoadingCollectionReusableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.register(UINib(nibName: "LoadingReusableView", bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "loadingView")
    }
    
    func search(asNew isNew: Bool) {
        if isNew {
            query = searchTextField.text!
            page = 1
        } else {
            page = page + 1
        }
        let searchText = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !searchText.isEmpty else {
            return
        }
        isLoading = true
        Flickr.instance.searchImages(withQuery: searchText, ofPage: page) { (flickrSearch, error) in
            guard error == nil else {
                print(error!)
                let alert = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if let searcResult = flickrSearch {
                if isNew {
                    self.images = searcResult.photos.photos
                } else {
                    self.images += searcResult.photos.photos
                }
                self.isLoading = false
                DispatchQueue.main.async {
                   self.collectionView.reloadData()
                }
            }
        }
    }

}

// TextField Delegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search(asNew: true)
        return true
    }
}

// CollectionView Delegate & DataSource & Layout
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard case let cell as FlickrImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath)
        }
        
        cell.flickrSource = images[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let loadingView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingView", for: indexPath) as! LoadingCollectionReusableView
            loadingView.activityIndicator?.isHidden = !isLoading
            self.loaingView = loadingView
            return loadingView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loaingView?.activityIndicator?.startAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loaingView?.activityIndicator?.stopAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10;
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ( self.collectionView.frame.size.width - 40 ) / 3, height: ( self.collectionView.frame.size.width - 40 ) / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading {
            return .zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        }
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleItems = collectionView.indexPathsForVisibleItems
        visibleItems.forEach { (indexPath) in
            if indexPath.row == self.images.count - 1 && !isLoading { // is last item visible?
                isLoading = true
                search(asNew: false)
            }
        }
    }
}
