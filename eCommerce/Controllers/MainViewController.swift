//
//  ViewController.swift
//  eCommerce
//
//  Created by Денис on 29.08.2022.
//

import UIKit

class MainViewController: UIViewController, FilterDelegateProtocol {

    var searchController = UISearchController(searchResultsController: nil)
    var selectedCategoryIndex: IndexPath?
    let categoryList = Bundle.main.decode([CategoryListModel].self, from: "categoryList.json")
    
    var favoritesBadge = UIView()
    var cartBadge = UIView()
    
    var hotSales = [PhonesContentModel]()
    var bestSeller = [PhonesContentModel]()
    var filteredBestSeller = [PhonesContentModel]()
    
    lazy var dataSource = makeDataSource()
    typealias DataSource = UICollectionViewDiffableDataSource<Section, PhonesContentModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, PhonesContentModel>
    let dataManager = DataManager.shared
    
    @IBOutlet weak var contentCollectionView: UICollectionView!
    @IBOutlet weak var categorySelector: UICollectionView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var qrButton: UIButton!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var favoritesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentCollectionView.delegate = self
        fetch()
        setupCategorySelectorCollectionView()
        setupTabBar()
        searchBarSetup()
        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBarBadges()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        cartBadge.removeFromSuperview()
        favoritesBadge.removeFromSuperview()
    }
    
    // MARK: Fetch from API
    private func fetch() {
        let url = URLManager.shared.mainScreenURL
        NetworkManager.shared.loadJson(urlString: url) {
            [weak self] (result: Result<PhonesContent, Error>) in
            switch result {
            case .success(let data):
                let hotSales = data.homeStore
                for product in hotSales {
                    let hotSalesProduct = PhonesContentModel(productId: product.id,
                                                             isNew: product.isNew,
                                                             title: product.title,
                                                             subtitle: product.subtitle,
                                                             picture: product.picture,
                                                             isBuy: product.isBuy)
                    self?.hotSales.append(hotSalesProduct)
                }
                
                let bestSeller = data.bestSeller
                for product in bestSeller {
                    let bestSellerProduct = PhonesContentModel(productId: product.id, title: product.title, picture: product.picture, isFavorites: false, priceWithoutDiscount: product.priceWithoutDiscount, discountPrice: product.discountPrice)
                    self?.bestSeller.append(bestSellerProduct)
                    
                }
                self?.applySnapshot(animated: true, visibleArray: self!.bestSeller)
            case .failure(let error):
                print("WE GOT ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - TabBar configs
    @IBAction func tabBarButtons(_ sender: Any) {
        let tag = (sender as AnyObject).tag
        switch tag {
        case 0:
            performSegue(withIdentifier: "cart", sender: nil)
        case 1:
            performSegue(withIdentifier: "favorites", sender: nil)
        default:
            break
        }
    }
    
    private func setupTabBar() {
        tabBarView.layer.cornerRadius = tabBarView.frame.size.height / 2
        tabBarView.clipsToBounds = true
    }
    
    private func setupTabBarBadges() {
        if dataManager.productsInCart.count > 0 {
            cartBadge = showBadge(with: dataManager.productsInCart.count)
            cartButton.addSubview(cartBadge)
        } else {
            cartBadge.removeFromSuperview()
        }
        
        if dataManager.favoriteProducts.count > 0 {
            favoritesBadge = showBadge(with: dataManager.favoriteProducts.count)
            favoritesButton.addSubview(favoritesBadge)
        } else {
            favoritesBadge.removeFromSuperview()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let detailsVC = segue.destination as! DetailsViewController
            if let fakeChose = bestSeller.first(where: { $0.productId == 3333 }) {
                detailsVC.fakeChosenPhone = fakeChose
            }
        }
        if segue.identifier == "filter" {
            filteredBestSeller.removeAll()
            applySnapshot(animated: false, visibleArray: bestSeller)
            let detailsVC = segue.destination as! FilterViewController
            detailsVC.delegate = self
        }
    }
    
    func filterByBrand(_ brand: String) {
        filteredBestSeller = filteredPhones(for: brand)
        applySnapshot(animated: true, visibleArray: filteredBestSeller)
    }
    
    func filterByPrice(_ from: Int, _ to: Int) {
        print("from: \(from), to: \(to)")
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
    }
}
