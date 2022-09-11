//
//  TableViewReusableCell.swift
//  eCommerce
//
//  Created by Денис on 08.09.2022.
//

import UIKit

protocol TableViewCellDelegate: AnyObject {
    func deleteCellby(_ index: IndexPath)
}

class TableViewReusableCell: UITableViewCell {
    
    weak var delegate: TableViewCellDelegate?
    var dataProvider = DataProvider()
    
    private var image: UIImage? {
        didSet {
            productImage.image = image
            activityIndicatorView.stopAnimating()
            activityIndicatorView.isHidden = true
        }
    }
    
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var stepper: UIStackView!
    @IBOutlet weak var itemsCountLabel: UILabel!
    
    func setupForFavorites(model: PhonesContentModel) {
        activityIndicatorView.startAnimating()
        activityIndicatorView.isHidden = false
        
        guard model.picture != nil else { return }
        let urlString = model.picture!
        let url = URL(string: urlString)!
        dataProvider.downloadImage(url: url) { image in
            self.image = image
        }
        productName.text = model.title
        guard model.discountPrice != nil else { return }
        priceLabel.text = "$\(model.priceWithoutDiscount!)"
    }
    
    func setupForCart(model: PhonesContentModel) {
        activityIndicatorView.startAnimating()
        activityIndicatorView.isHidden = false
        
        guard model.picture != nil else { return }
        let urlString = model.picture!
        let url = URL(string: urlString)!
        dataProvider.downloadImage(url: url) { image in
            self.image = image
        }
        
        productName.text = model.title
        backgroundColor = .darkBlue
        productName.textColor = .white
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        let index = self.indexPath
        delegate?.deleteCellby(index!)
    }
}

// Get indexPath
extension UITableViewCell {
    var tableView: UITableView? {
        return self.next(of: UITableView.self)
    }
    var indexPath: IndexPath? {
        return self.tableView?.indexPath(for: self)
    }
}
