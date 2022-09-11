//
//  FilterViewController.swift
//  eCommerce
//
//  Created by Денис on 03.09.2022.
//


import UIKit

class FilterViewController: UIViewController, UISheetPresentationControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet var filterButtons: [UIButton]!
    @IBOutlet weak var brandButton: UIButton!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    private var brandName: String? {
        didSet {
            brandButton.setTitle(brandName, for: .normal)
        }
    }
    
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.isEnabled = false
        sheetPresentationController.delegate = self
        sheetPresentationController.selectedDetentIdentifier = .medium
        sheetPresentationController.detents = [.medium()]
        addArrowImageTo(buttons: filterButtons)
    }
    
    func addArrowImageTo(buttons: [UIButton]) {
        var config = UIButton.Configuration.filled()
        config.titleTextAttributesTransformer =
        UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont(name: "MarkPro", size: 18)
            return outgoing
        }
        let arrowColor = #colorLiteral(red: 0.7540718913, green: 0.7540718913, blue: 0.7540718913, alpha: 1)
        config.image = UIImage(systemName: "chevron.down")?.withTintColor(arrowColor, renderingMode: .alwaysOriginal)
        config.imagePadding = 5
        config.imagePlacement = .trailing
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
        for button in buttons {
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            let color = #colorLiteral(red: 0.8894182444, green: 0.8894181848, blue: 0.8894182444, alpha: 1).cgColor
            button.layer.borderColor = color
            button.configuration = config
        }
    }
        
    @IBAction func brandButtonAction(_ sender: Any) {
        guard let popTV = storyboard?.instantiateViewController(withIdentifier: "brandsTableView") as? BrandsPopover else { return }
        popTV.modalPresentationStyle = .popover
        popTV.delegate = self
        let popOverTV = popTV.popoverPresentationController
        popOverTV?.delegate = self
        popOverTV?.sourceView = brandButton
        popOverTV?.sourceRect = CGRect(x: brandButton.bounds.midX, y: brandButton.bounds.midY, width: 0, height: 0)
        popTV.preferredContentSize = CGSize(width: 250, height: 250)
        present(popTV, animated: true)
    }
    
    @IBAction func priceButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "price", sender: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "price" {
            let priceVC = segue.destination as! PriceSheet
            priceVC.delegate = self
        }
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func doneButton(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: Buttons delegate methods
extension FilterViewController: BrandsDelegate {
    func brandName(_ title: String) {
        brandButton.setTitle(title, for: .normal)
        doneButton.isEnabled = true
    }
}

extension FilterViewController: PriceDelegate {
    func chosedPriceRange(_ from: Int, _ to: Int) {
        print("from: \(from), to: \(to)")
        priceButton.setTitle("$\(from) - $\(to)", for: .normal)
        doneButton.isEnabled = true
    }
}
