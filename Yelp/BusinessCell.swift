//
//  BusinessCell.swift
//  Yelp
//
//  Created by Mike Lin on 2/13/18.
//  Copyright © 2018 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
    
    //UI Properties
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = label.font.withSize(15)
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        return label
    }()
    
    let reviewsCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = label.font.withSize(13)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(13)
        return label
    }()
    
    let categoriesLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(13)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(13)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(13)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 3
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let ratingImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    //used to calculate row number of cell
    var cellRow: Int?
    
    var business: Business! {
        didSet {
            nameLabel.text = "\(cellRow!). " + business.name!
            reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
            addressLabel.text = business.address
            //done in the case that network is too slow to retrieve pictures
            //will find better fix in the future
            if business.imageURL != nil {
                thumbImageView.setImageWith(business.imageURL!)
            }
            categoriesLabel.text = business.categories
            ratingImageView.setImageWith(business.ratingImageURL!)
            distanceLabel.text = business.distance
            priceLabel.text = "$$"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //add views to cell's contentView
        [nameLabel, reviewsCountLabel, addressLabel, categoriesLabel, thumbImageView, ratingImageView,
         distanceLabel, priceLabel].forEach{contentView.addSubview($0)}
        //sets up constraints for the views of the cell
        setUpCell()
    }
    
    private func setUpCell() {
        let margins = contentView.layoutMarginsGuide
        thumbImageView.anchor(top: margins.topAnchor, leading: margins.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 4, bottom: 0, right: 0), size: .init(width: 65, height: 65))
        
        nameLabel.numberOfLines = 0
        nameLabel.anchor(top: margins.topAnchor, leading: thumbImageView.trailingAnchor, bottom: nil, trailing: distanceLabel.leadingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 12))
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        
        ratingImageView.anchor(top: nameLabel.bottomAnchor, leading: thumbImageView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 4, left: 8, bottom: 0, right: 0), size: .init(width: 83, height: 15))
        
        addressLabel.anchor(top: ratingImageView.bottomAnchor, leading: thumbImageView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 4, left: 8, bottom: 0, right: 0))
        
        reviewsCountLabel.anchor(top: nil, leading: ratingImageView.trailingAnchor, bottom: addressLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 8, bottom: 3, right: 0))
        reviewsCountLabel.centerXAnchor.constraint(equalTo: ratingImageView.centerXAnchor)
        
        categoriesLabel.anchor(top: addressLabel.bottomAnchor, leading: thumbImageView.trailingAnchor, bottom: margins.bottomAnchor, trailing: margins.trailingAnchor, padding: .init(top: 2, left: 8, bottom: 2, right: 4))
        categoriesLabel.numberOfLines = 0
        
        distanceLabel.anchor(top: margins.topAnchor, leading: nil, bottom: nil, trailing: margins.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 4))
        distanceLabel.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor)
        distanceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        distanceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        priceLabel.anchor(top: distanceLabel.bottomAnchor, leading: nil, bottom: nil, trailing: margins.trailingAnchor, padding: .init(top: 4, left: 0, bottom: 0, right: 4))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }
}







