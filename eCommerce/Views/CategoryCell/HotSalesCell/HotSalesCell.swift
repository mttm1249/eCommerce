//
//  HotSalesCell.swift
//  eCommerce
//
//  Created by Денис on 04.09.2022.
//

import UIKit

class HotSalesCell: UICollectionViewCell {
    
    var dataProvider = DataProvider()
    
    private var image: UIImage? {
        didSet {
            imageView.image = image
            activityIndicatorView.stopAnimating()
            activityIndicatorView.isHidden = true
        }
    }
    
    @IBOutlet weak var newIcon: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    
    func setup(model: PhonesContentModel) {
        activityIndicatorView.startAnimating()
        activityIndicatorView.isHidden = false
        
        let urlString = model.picture!
        let url = URL(string: urlString)!
        dataProvider.downloadImage(url: url) { image in
            self.image = image
        }
        titleLabel.text = model.title
        detailsLabel.text = model.subtitle
        if model.isNew == true {
            newIcon.isHidden = false
        } else {
            newIcon.isHidden = true
        }
    }
}
