//
//  NewsCollectionViewCell.swift
//  NewsApp
//
//  Created by Roman Kniukh on 21.03.21.
//

import UIKit
import SnapKit
import ReadMoreTextView
import ExpandableLabel

class NewsCollectionViewCell: UICollectionViewCell {
    // MARK: - Variables
    static let identifier = "NewsCollectionViewCell"
    
    private let edgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
    private let contentOffset: CGFloat = 20
    private let imageHeight: CGFloat = UIScreen.main.bounds.width * 9 / 16
    private lazy var isFirstLoad = true
    
    // MARK: - GUi Variables
    private let descriptionLabel: ExpandableLabel = {
        let label = ExpandableLabel()

        label.numberOfLines = 3
        label.textColor = .gray
        label.layoutIfNeeded()
        label.ellipsis = NSAttributedString(string: "...")
        label.collapsedAttributedLink = NSAttributedString(string: "Show More",
                                                           attributes: [
                                                            NSAttributedString.Key.foregroundColor : UIColor.blue,
                                                            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)])

        label.shouldCollapse = true
        label.collapsed = false
        
        
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(named: "defaultImage")
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        label.numberOfLines = 1
        
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.hidesWhenStopped = true
        
        return loadingIndicator
    }()
      
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.borderWidth = 4
        contentView.addSubview(self.imageView)
        self.imageView.addSubview(loadingIndicator)
        contentView.addSubview(self.titleLabel)
        contentView.addSubview(self.descriptionLabel)
        contentView.addSubview(self.dateLabel)
        contentView.clipsToBounds = true
        
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func constraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.imageView.snp.bottom).offset(self.contentOffset)
            make.left.right.equalToSuperview().inset(self.edgeInsets)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(self.imageHeight)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        dateLabel.setContentCompressionResistancePriority(.defaultHigh + 1, for: .vertical)
        dateLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(self.edgeInsets)
        }
        
        descriptionLabel.setContentHuggingPriority(.defaultLow - 1, for: .vertical)
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(self.contentOffset)
            make.left.right.equalToSuperview().inset(self.edgeInsets)
            make.bottom.equalTo(self.dateLabel.snp.top).offset(-self.contentOffset)
        }
    }
    
    public func configure(description: String,title: String, image: String?, date: String) {
        descriptionLabel.text = description
        titleLabel.text = title
        loadingIndicator.startAnimating()
        image?.loadImage(completion: { [weak self] (image) in
            self?.imageView.image = image
            self?.loadingIndicator.stopAnimating()
        })
        dateLabel.text = date
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel.collapsed = true
        self.descriptionLabel.text = nil
        self.titleLabel.text = nil
        self.dateLabel.text = nil
        self.imageView.image = nil
    }
}
