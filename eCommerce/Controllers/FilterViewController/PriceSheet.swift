//
//  PriceSheet.swift
//  eCommerce
//
//  Created by Денис on 11.09.2022.
//

protocol PriceDelegate: AnyObject {
    func chosedPriceRange(_ from: Int,_ to: Int)
}

import UIKit
import DoubleSlider

class PriceSheet: UIViewController, UISheetPresentationControllerDelegate, UIViewControllerTransitioningDelegate {
    
    var labels: [String] = []
    var doubleSlider: DoubleSlider!
    weak var delegate: PriceDelegate?
    @IBOutlet weak var backgroundView: UIView!
    
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sheetPresentationController.prefersGrabberVisible = true
        sheetPresentationController.delegate = self
        sheetPresentationController.selectedDetentIdentifier = .medium
        sheetPresentationController.detents = [.medium()]
        
        makeLabels()
        setupDoubleSlider()
        doubleSlider.labelDelegate = self
        doubleSlider.numberOfSteps = labels.count
        doubleSlider.labelsAreHidden = false
        doubleSlider.smoothStepping = true
    }
    
    private func makeLabels() {
        for num in stride(from: 0, to: 10000, by: 1) {
            labels.append("$\(num)")
        }
        labels.append("$10000")
    }
    
    private func setupDoubleSlider() {
        let height: CGFloat = 38.0
        let width = backgroundView.bounds.width
        
        let frame = CGRect(
            x: backgroundView.bounds.minX - 2.0,
            y: backgroundView.bounds.midY - (height / 2.0),
            width: width,
            height: height
        )
        
        doubleSlider = DoubleSlider(frame: frame)
        doubleSlider.trackHighlightTintColor = .orangeColor
        doubleSlider.trackTintColor = .darkBlue
        doubleSlider.translatesAutoresizingMaskIntoConstraints = false
        doubleSlider.labelDelegate = self
        doubleSlider.numberOfSteps = labels.count
        doubleSlider.smoothStepping = true
        
        let labelOffset: CGFloat = 8.0
        doubleSlider.lowerLabelMarginOffset = labelOffset
        doubleSlider.upperLabelMarginOffset = labelOffset
        doubleSlider.lowerValueStepIndex = 0
        doubleSlider.upperValueStepIndex = labels.count - 1
        doubleSlider.editingDidEndDelegate = self
        backgroundView.addSubview(doubleSlider)
    }
}

extension PriceSheet: DoubleSliderEditingDidEndDelegate {
    func editingDidEnd(for doubleSlider: DoubleSlider) { 
        delegate?.chosedPriceRange(doubleSlider.lowerValueStepIndex, doubleSlider.upperValueStepIndex)
    }
}

extension PriceSheet: DoubleSliderLabelDelegate {
    func labelForStep(at index: Int) -> String? {
        return labels.item(at: index)
    }
}

extension Array {
    func item(at index: Int) -> Element? {
        return (index < self.count && index >= 0) ? self[index] : nil
    }
}
