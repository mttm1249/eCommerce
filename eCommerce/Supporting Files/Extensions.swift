//
//  Extensions.swift
//  eCommerce
//
//  Created by Денис on 05.09.2022.
//

import UIKit

// MARK: Sections of main screen collectionView
extension MainViewController {
    enum Section: Int, CaseIterable {
        case  hot, best
        
        func description() -> String {
            switch self {
            case .hot:
                return "Hot sales"
            case .best:
                return "Best seller"
            }
        }
    }
}

// MARK: Badges
extension MainViewController {
    func showBadge(with count: Int) -> UIView {
        let badgeCount = UILabel(frame: CGRect(x: 15, y: -13, width: 20, height: 20))
        badgeCount.layer.borderColor = UIColor.clear.cgColor
        badgeCount.layer.borderWidth = 2
        badgeCount.layer.cornerRadius = badgeCount.bounds.size.height / 2
        badgeCount.textAlignment = .center
        badgeCount.layer.masksToBounds = true
        badgeCount.textColor = .white
        badgeCount.font = badgeCount.font.withSize(12)
        badgeCount.backgroundColor = .red
        badgeCount.text = String(count)
        return badgeCount
    }
}

extension DetailsViewController {
    func showBadge(with count: Int) -> UIView {
        let badgeCount = UILabel(frame: CGRect(x: 25, y: -8, width: 20, height: 20))
        badgeCount.layer.borderColor = UIColor.clear.cgColor
        badgeCount.layer.borderWidth = 2
        badgeCount.layer.cornerRadius = badgeCount.bounds.size.height / 2
        badgeCount.textAlignment = .center
        badgeCount.layer.masksToBounds = true
        badgeCount.textColor = .white
        badgeCount.font = badgeCount.font.withSize(12)
        badgeCount.backgroundColor = .red
        badgeCount.text = String(count)
        return badgeCount
    }
}

// MARK: Work with cell delegate
extension MainViewController: BestCellDelegate {
    func saveCellIndex(_ index: IndexPath) {
        var product = bestSeller[index.item]
        if !dataManager.favoriteProducts.contains(product) {
            product.isFavorites = true
            product.savedIndex = index
            dataManager.favoriteProducts.append(product)
            dataManager.savedIndex.append(index)
            favoritesBadge.removeFromSuperview()
            favoritesBadge = showBadge(with: dataManager.favoriteProducts.count)
            favoritesButton.addSubview(favoritesBadge)
        } else {
            let filteredProducts = dataManager.favoriteProducts.filter { $0 != product }
            let filteredIndexes = dataManager.savedIndex.filter { $0 != index }
            dataManager.favoriteProducts = filteredProducts
            dataManager.savedIndex = filteredIndexes
            favoritesBadge.removeFromSuperview()
            favoritesBadge = showBadge(with: filteredProducts.count)
            favoritesButton.addSubview(favoritesBadge)
            if filteredProducts.count == 0 {
                favoritesBadge.removeFromSuperview()
            }
        }
    }
}

// MARK: - Layout Handling
extension MainViewController {
    func configureLayout() {
        let hotSalesCell = UINib(nibName: "HotSalesCell", bundle: nil)
        contentCollectionView.register(hotSalesCell, forCellWithReuseIdentifier: "hotSalesCell")
        
        let bestSellerCell = UINib(nibName: "BestSellerCell", bundle: nil)
        contentCollectionView.register(bestSellerCell, forCellWithReuseIdentifier: "bestSellerCell")
        
        contentCollectionView.register(
            SectionHeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier
        )
        contentCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            if sectionIndex == 0 {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets.trailing = 5
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                
                section.orthogonalScrollingBehavior = .paging
                
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
                ]
                return section
            } else {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(300)))
                item.contentInsets.bottom = 16
                item.contentInsets.trailing = 5
                item.contentInsets.leading = 5
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1000)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
                
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind:  UICollectionView.elementKindSectionHeader, alignment: .topLeading)
                ]
                return section
            }
        })
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func setupCategorySelectorCollectionView() {
        categorySelector.dataSource = self
        categorySelector.delegate = self
        let categoryCell = UINib(nibName: "CategoryCell", bundle: nil)
        categorySelector.register(categoryCell, forCellWithReuseIdentifier: "categoryCell")
        selectedCategoryIndex = [0, 0]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let categoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as? CategoryCell {
            categoryCell.setup(model: categoryList[indexPath.row])
            
            if selectedCategoryIndex ==  indexPath {
                categoryCell.categoryCircle.backgroundColor = .orangeColor
                categoryCell.categoryImage.tintColor = .white
            } else {
                categoryCell.categoryCircle.backgroundColor = .white
                categoryCell.categoryImage.tintColor = #colorLiteral(red: 0.7019592524, green: 0.7019620538, blue: 0.761980474, alpha: 1)
            }
            return categoryCell
        }
        return UICollectionViewCell()
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            if sectionIndex == 0 {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets.trailing = 5
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                
                section.orthogonalScrollingBehavior = .paging
                
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
                ]
                return section
            } else {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(300)))
                item.contentInsets.bottom = 16
                item.contentInsets.trailing = 5
                item.contentInsets.leading = 5
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1000)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
                
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind:  UICollectionView.elementKindSectionHeader, alignment: .topLeading)
                ]
                return section
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 71, height: 93)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == contentCollectionView {
            if indexPath.section == 1 {
                performSegue(withIdentifier: "showDetails", sender: nil)
            }
        } else {
            categorySelector.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            selectedCategoryIndex = indexPath
            categorySelector.reloadData()
        }
    }
    
    // MARK: - MAKE DATA SOURCE
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: contentCollectionView,
            cellProvider: { [self] (collectionView, indexPath, video) ->
                UICollectionViewCell? in
                guard let section = Section(rawValue: indexPath.section) else {
                    fatalError("Unknown section kind")
                }
                switch section {
                case .hot:
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: "hotSalesCell",
                        for: indexPath) as? HotSalesCell
                    cell?.setup(model: hotSales[indexPath.row])
                    cell?.layer.cornerRadius = 10
                    return cell
                case .best:
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bestSellerCell", for: indexPath) as? BestSellerCell
                    cell?.delegate = self
                    cell?.setup(model: bestSeller[indexPath.row])
                    cell?.layer.cornerRadius = 10
                    return cell
                }
            })
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            let section = self.dataSource.snapshot()
                .sectionIdentifiers[indexPath.section]
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderReusableView.reuseIdentifier,
                for: indexPath) as? SectionHeaderReusableView
            view?.titleLabel.text = section.description()
            return view
        }
        return dataSource
    }
    
    func applySnapshot(animated: Bool, visibleArray: [PhonesContentModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.hot, .best])
        snapshot.appendItems(hotSales, toSection: .hot)
        snapshot.appendItems(visibleArray, toSection: .best)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let detailsVC = segue.destination as! DetailsViewController
            if let fakeChose = bestSeller.first(where: { $0.productId == 3333 }) {
                detailsVC.fakeChosenPhone = fakeChose
            }
        }
    }
}

// MARK: Search
extension MainViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func searchBarSetup() {
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField,
           let iconView = textField.leftView as? UIImageView {
            iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
            iconView.tintColor = .orangeColor
        }
        
        let font = UIFont(name: "MarkPro", size: 12)!
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString.init(string: " Search", attributes: [.font: font, .foregroundColor: UIColor.searchBarText])
        
        searchBarView.addSubview(searchController.searchBar)
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchTextField.backgroundColor = .none
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.layoutMargins = .init(top: 0, left: 0, bottom: 20, right: 85)
        searchController.searchBar.tintColor = .darkBlue
        
        searchController.searchBar.searchTextField.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredBestSeller = filteredPhones(for: searchController.searchBar.text)
        applySnapshot(animated: true, visibleArray: filteredBestSeller)
    }
    
    func filteredPhones(for queryOrNil: String?) -> [PhonesContentModel] {
        guard let query = queryOrNil, !query.isEmpty else { return bestSeller }
        return bestSeller.filter { product in
            let matches = product.title!.lowercased().contains(query.lowercased())
            return matches
        }
    }
}
