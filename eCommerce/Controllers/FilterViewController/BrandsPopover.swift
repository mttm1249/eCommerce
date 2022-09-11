//
//  BrandsPopover.swift
//  eCommerce
//
//  Created by Денис on 11.09.2022.
//

import UIKit

protocol BrandsDelegate: AnyObject {
    func brandName(_ title: String)
}

class BrandsPopover: UITableViewController {
    
    private let brandsArray = ["Samsung", "Motorola", "Xiaomi"]
    weak var delegate: BrandsDelegate?
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brandsArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "brandCell", for: indexPath)
        cell.textLabel?.text = brandsArray[indexPath.row]
        cell.textLabel?.font = UIFont(name: "MarkPro", size: 18)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let brandName = brandsArray[indexPath.row]
        delegate?.brandName(brandName)
        dismiss(animated: true)
    }
}
