//
//  DetailsViewController.swift
//  eCommerce
//
//  Created by Денис on 05.09.2022.
//

import UIKit
import Cosmos

class DetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var fakeChosenPhone: PhonesContentModel?
    private let flowLayout = CustomCenteredLayout()
    private var currentProduct: DetailsModel?
    private var productImages = [String]()
    private var dataManager = DataManager.shared
    
    private var cartBadge = UIView()
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var cartButton: UIButton!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var cpuLabel: UILabel!
    @IBOutlet weak var cameraLabel: UILabel!
    @IBOutlet weak var ssdLabel: UILabel!
    @IBOutlet weak var sdLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addToCartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
        setupCollectionView()
        if dataManager.productsInCart.count > 0 {
            cartButton.addSubview(showBadge(with: dataManager.productsInCart.count))
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = flowLayout
        collectionView.contentInsetAdjustmentBehavior = .always
        let centerCell = UINib(nibName: "CenteredCollectionViewCell", bundle: nil)
        collectionView.register(centerCell, forCellWithReuseIdentifier: "centeredCollectionViewCell")
    }
    
    private func displaySetting() {
        guard currentProduct != nil else { return }
        textLabel.text = currentProduct?.title
        cpuLabel.text = currentProduct?.cpu
        cameraLabel.text = currentProduct?.camera
        ssdLabel.text = currentProduct?.ssd
        sdLabel.text = currentProduct?.sd
        if currentProduct?.rating != nil {
            ratingView.rating = currentProduct!.rating
        }
        collectionView.reloadData()
        guard (fakeChosenPhone != nil) && (fakeChosenPhone?.priceWithoutDiscount) != nil else { return }
        addToCartButton.setTitle("Add to cart   $\(fakeChosenPhone!.priceWithoutDiscount!)", for: .normal)
    }
    
    // Fetch from API
    private func fetch() {
        let url = URLManager.shared.detailsScreenURL
        NetworkManager.shared.loadJson(urlString: url) {
            [weak self] (result: Result<DetailsModel, Error>) in
            switch result {
            case .success(let data):
                self?.currentProduct = data
                self?.productImages = data.images
                self?.displaySetting()
            case .failure(let error):
                print("WE GOT ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "centeredCollectionViewCell", for: indexPath) as! CenteredCollectionViewCell
        if currentProduct != nil {
            cell.setup(model: productImages[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func cartButton(_ sender: Any) {
        performSegue(withIdentifier: "cart", sender: nil)
        
    }
    
    @IBAction func addToCartButtonAction(_ sender: Any) {
        guard fakeChosenPhone != nil else { return }
        dataManager.productsInCart.append(fakeChosenPhone!)
        cartButton.addSubview(showBadge(with: dataManager.productsInCart.count))
    }
}
