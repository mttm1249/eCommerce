//
//  BestSellerCell.swift
//  eCommerce
//
//  Created by Денис on 05.09.2022.
//

import UIKit

protocol BestCellDelegate: AnyObject {
    func saveCellIndex(_ index: IndexPath)
}

class BestSellerCell: UICollectionViewCell {
    
    weak var delegate: BestCellDelegate?
    var dataProvider = DataProvider()
    var selectedProduct = false
    
    private var image: UIImage? {
        didSet {
            productImage.image = image
            activityIndicatorView.stopAnimating()
            activityIndicatorView.isHidden = true
        }
    }
    
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var priceWithDiscountLabel: UILabel!
    @IBOutlet weak var priceWithoutDiscountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var favoritesIndicator: UIImageView!
    
    func setup(model: PhonesContentModel) {
        activityIndicatorView.startAnimating()
        activityIndicatorView.isHidden = false
        
        let urlString = model.picture!
        let url = URL(string: urlString)!
        dataProvider.downloadImage(url: url) { image in
            self.image = image
        }
        priceWithDiscountLabel.text = "$\(model.priceWithoutDiscount!)"
        priceWithoutDiscountLabel.text = "$\(model.discountPrice!)"
        priceWithoutDiscountLabel.strikethroughStyle()
        titleLabel.text = model.title
        
        if selectedProduct == false {
            favoritesIndicator.image = UIImage(systemName: "heart")?.withTintColor(.orangeColor, renderingMode: .alwaysTemplate)
        } else {
            favoritesIndicator.image = UIImage(systemName: "heart.fill")?.withTintColor(.orangeColor, renderingMode: .alwaysTemplate)
        }
    }
    
    @IBAction func addToFavoritesButton(_ sender: Any) {
        let index = self.indexPath
        delegate?.saveCellIndex(index!)
        checkIndicator(by: index!)
        selectedProduct = true
    }
    
    func checkIndicator(by index: IndexPath) {
        if DataManager.shared.savedIndex.contains(index) {
            favoritesIndicator.image = UIImage(systemName: "heart.fill")?.withTintColor(.orangeColor, renderingMode: .alwaysTemplate)
        } else {
            favoritesIndicator.image = UIImage(systemName: "heart")?.withTintColor(.orangeColor, renderingMode: .alwaysTemplate)
        }
    }
}

extension UILabel {
    func strikethroughStyle() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}

// Get indexPath
extension UIResponder {
    func next<U: UIResponder>(of type: U.Type = U.self) -> U? {
        return self.next.flatMap({ $0 as? U ?? $0.next() })
    }
}

extension UICollectionViewCell {
    var collectionView: UICollectionView? {
        return self.next(of: UICollectionView.self)
    }
    var indexPath: IndexPath? {
        return self.collectionView?.indexPath(for: self)
    }
}
