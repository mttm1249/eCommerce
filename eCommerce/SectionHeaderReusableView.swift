
import UIKit

class SectionHeaderReusableView: UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: SectionHeaderReusableView.self)
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "MarkPro-Bold", size: 25)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .darkBlue
        label.textAlignment = .left
        return label
    }()
    
    lazy var headerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel!.font = UIFont(name: "MarkPro", size: 15)!
        button.setTitleColor(.orangeColor, for: .normal)
        button.setTitle("see more", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(headerButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            headerButton.topAnchor.constraint(equalTo: topAnchor, constant: -10),
            headerButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5),
            headerButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
