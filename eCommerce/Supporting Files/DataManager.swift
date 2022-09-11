//
//  DataManager.swift
//  eCommerce
//
//  Created by Денис on 06.09.2022.
//

import Foundation

class DataManager {
    
    var favoriteProducts = [PhonesContentModel]()
    var productsInCart = [PhonesContentModel]()
    var savedIndex = [IndexPath]()
    var brandName: String?
    
    static let shared = DataManager()
    private init() {}
}
