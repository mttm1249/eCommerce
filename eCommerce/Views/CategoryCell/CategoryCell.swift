//
//  CategoryCell.swift
//  eCommerce
//
//  Created by Денис on 02.09.2022.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryCircle: UIView!
    
    func setup(model: CategoryListModel) {
        categoryImage.image = UIImage(named: model.categoryImage)
        categoryName.text = model.categoryName
        categoryName.textColor = .darkBlue
    }
}
