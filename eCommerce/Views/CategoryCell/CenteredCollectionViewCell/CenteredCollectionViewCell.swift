//
//  CenteredCollectionViewCell.swift
//  eCommerce
//
//  Created by Денис on 09.09.2022.
//

import UIKit

class CenteredCollectionViewCell: UICollectionViewCell {
    
    var dataProvider = DataProvider()
    
    private var image: UIImage? {
        didSet {
            imageView.image = image
            activityIndicatorView.stopAnimating()
            activityIndicatorView.isHidden = true
        }
    }
    
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    
    func setup(model: String) {
        activityIndicatorView.startAnimating()
        activityIndicatorView.isHidden = false
        
        let urlString = model
        let url = URL(string: urlString)!
        dataProvider.downloadImage(url: url) { image in
            self.image = image
        }
    }
}
