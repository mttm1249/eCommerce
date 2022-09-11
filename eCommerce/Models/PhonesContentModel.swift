//
//  HotSalesModel.swift
//  eCommerce
//
//  Created by Денис on 02.09.2022.
//

import Foundation

struct PhonesContentModel: Codable, Hashable {
    var id = UUID()
    var productId: Int?
    var isNew: Bool?
    var title, subtitle: String?
    var picture: String?
    var isBuy: Bool?
    var isFavorites: Bool?
    var priceWithoutDiscount, discountPrice: Int?
    var savedIndex: IndexPath?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: PhonesContentModel, rhs: PhonesContentModel) -> Bool {
        return lhs.id == rhs.id
    }
}

