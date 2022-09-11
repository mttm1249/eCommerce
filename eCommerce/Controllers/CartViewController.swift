//
//  ProfileViewController.swift
//  eCommerce
//
//  Created by Денис on 31.08.2022.
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var productsInCart: [PhonesContentModel] = []
    private var uniqueObjectsArray = NSMutableOrderedSet()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        registerTableViewCell()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    // Register custom cell
    private func registerTableViewCell() {
        let customCell = UINib(nibName: "TableViewReusableCell", bundle: nil)
        self.tableView.register(customCell,forCellReuseIdentifier: "tableViewReusableCell")
    }
    
    func setup() {
        productsInCart = DataManager.shared.productsInCart
        uniqueObjectsArray.addObjects(from: productsInCart)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uniqueObjectsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewReusableCell") as? TableViewReusableCell {
            cell.delegate = self
            cell.setupForCart(model: productsInCart[indexPath.row])
            cell.itemsCountLabel.text = "\(productsInCart.count)"
            cell.priceLabel.text = "$\(productsInCart.count * productsInCart[indexPath.row].priceWithoutDiscount!)"
            totalPriceLabel.text = "$\(productsInCart.count * productsInCart[indexPath.row].priceWithoutDiscount!) us"
            deliveryLabel.text = "Free"
            return cell
        }
        return UITableViewCell()
    }
    
    func deleteCell(with indexPath: IndexPath) {
        DataManager.shared.productsInCart.removeAll()
        productsInCart.remove(at: indexPath.row)
        uniqueObjectsArray.removeAllObjects()
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .middle)
        tableView.endUpdates()
        tableView.reloadRows(at: [indexPath], with: .middle)
    }
    
    @IBAction func checkoutButtonAction(_ sender: Any) {
    }
}


extension CartViewController: TableViewCellDelegate {
    func deleteCellby(_ index: IndexPath) {
        deleteCell(with: index)
        totalPriceLabel.text = "_"
        deliveryLabel.text = "_"
    }
    
}
