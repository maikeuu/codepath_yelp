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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let reviewsCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = label.font.withSize(13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let categoriesLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(13)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(13)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
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
    
    var business: Business! {
        didSet {
            nameLabel.text = business.name
            reviewsCountLabel.text = "\(business.reviewCount!) Reviews"
            addressLabel.text = business.address
            categoriesLabel.text = business.categories
            thumbImageView.setImageWith(business.imageURL!)
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
        let margins = contentView.layoutMarginsGuide
        
        //thumbImage
        setConstraints(thumbImageView, leadingAnchor: margins.leadingAnchor, leadingConstant: 8, topAnchor: margins.topAnchor, topConstant: 8, trailingAnchor: nil, trailingConstant: 0, bottomAnchor: nil, bottomConstant: 0, widthConstant: 65, heightConstant: 65)
        //nameLabel
        setConstraints(nameLabel, leadingAnchor: thumbImageView.trailingAnchor, leadingConstant: 8, topAnchor: margins.topAnchor, topConstant: 8, trailingAnchor: nil, trailingConstant: 0, bottomAnchor: nil, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        //ratingImage
        setConstraints(ratingImageView, leadingAnchor: thumbImageView.trailingAnchor, leadingConstant: 8, topAnchor: nameLabel.bottomAnchor, topConstant: 4, trailingAnchor: nil, trailingConstant: 0, bottomAnchor: nil, bottomConstant: 0, widthConstant: 83, heightConstant: 15)
        //addressLabel
        setConstraints(addressLabel, leadingAnchor: thumbImageView.trailingAnchor, leadingConstant: 8, topAnchor: ratingImageView.bottomAnchor, topConstant: 4, trailingAnchor: nil, trailingConstant: 0, bottomAnchor: nil, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        //reviewsCountLabel
        setConstraints(reviewsCountLabel, leadingAnchor: ratingImageView.trailingAnchor, leadingConstant: 15, topAnchor: nil, topConstant: 0, trailingAnchor: nil, trailingConstant: 0, bottomAnchor: addressLabel.topAnchor, bottomConstant: -3, widthConstant: 0, heightConstant: 0)
        reviewsCountLabel.centerXAnchor.constraint(equalTo: ratingImageView.centerXAnchor)
        //categoriesLabel
        setConstraints(categoriesLabel, leadingAnchor: thumbImageView.trailingAnchor, leadingConstant: 8, topAnchor: addressLabel.bottomAnchor, topConstant: 2, trailingAnchor: nil, trailingConstant: 0, bottomAnchor: nil, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        categoriesLabel.bottomAnchor.constraint(greaterThanOrEqualTo: margins.bottomAnchor, constant: 12)
        //distanceLabel
        setConstraints(distanceLabel, leadingAnchor: nameLabel.trailingAnchor, leadingConstant: 4, topAnchor: margins.topAnchor, topConstant: 8, trailingAnchor: margins.trailingAnchor, trailingConstant: 4, bottomAnchor: nil, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
        distanceLabel.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor)
        //priceLabel
        setConstraints(priceLabel, leadingAnchor: nil, leadingConstant: 0, topAnchor: distanceLabel.bottomAnchor, topConstant: 8, trailingAnchor: margins.trailingAnchor, trailingConstant: 4, bottomAnchor: nil, bottomConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func setConstraints(_ view: UIView, leadingAnchor: NSLayoutXAxisAnchor? = nil, leadingConstant: CGFloat = 0, topAnchor: NSLayoutYAxisAnchor? = nil, topConstant: CGFloat, trailingAnchor: NSLayoutXAxisAnchor? = nil, trailingConstant: CGFloat = 0, bottomAnchor: NSLayoutYAxisAnchor? = nil, bottomConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) {
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if heightConstant > 0 {
            view.heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        }
        if widthConstant > 0 {
            view.widthAnchor.constraint(equalToConstant: widthConstant).isActive = true
        }
        if let leadingAnchor = leadingAnchor {
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingConstant).isActive = true
        }
        if let topAnchor = topAnchor {
            view.topAnchor.constraint(equalTo: topAnchor
                , constant: topConstant).isActive = true
        }
        if let trailingAnchor = trailingAnchor {
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailingConstant).isActive = true
        }
        if let bottomAnchor = bottomAnchor {
            view.bottomAnchor.constraint(equalTo: bottomAnchor
                , constant: bottomConstant).isActive = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
