//
//  FavoritesViewController.swift
//  eCommerce
//
//  Created by Денис on 31.08.2022.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var productsInFavorites = [PhonesContentModel]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCell()
        tableView.delegate = self
        tableView.dataSource = self
        productsInFavorites = DataManager.shared.favoriteProducts
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productsInFavorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewReusableCell") as? TableViewReusableCell {
            cell.setupForFavorites(model: productsInFavorites[indexPath.row])
            cell.trashButton.isHidden = true
            cell.stepper.isHidden = true
            return cell
        }
        return UITableViewCell()
    }
    
    // Register custom cell
    private func registerTableViewCell() {
        let customCell = UINib(nibName: "TableViewReusableCell", bundle: nil)
        self.tableView.register(customCell,forCellReuseIdentifier: "tableViewReusableCell")
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true)
    }
}
