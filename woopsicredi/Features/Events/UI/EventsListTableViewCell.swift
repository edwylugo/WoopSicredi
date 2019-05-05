//
//  EventsListTableViewCell.swift
//  woopsicredi
//
//  Created by Edwy Lugo on 04/05/19.
//

import Foundation
import UIKit
import Kingfisher

class EventsListTableViewCell : UITableViewCell {
    var titleLabel: UILabel!
    var priceLabel: UILabel!
    var pictureImageView: UIImageView!
    var dateLabel: UILabel!
    
    var content: EventsListTableViewCellModel! {
        didSet {
            setupContent()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupContent() {
        titleLabel.text = content.title
        priceLabel.text = content.price
        let url = URL(string: content.pictureURL)
        pictureImageView.kf.setImage(with: url)
        dateLabel.text = content.date
    }
    
    func setupViews() {
        accessoryType = .disclosureIndicator
        
        pictureImageView = UIImageView()
        pictureImageView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.font = WSFont.FontTypes.bold.font(withSize: 18)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.textColor = WSColorPalette.fontColor
        
        priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = WSFont.FontTypes.regular.font(withSize: 14)
        priceLabel.textAlignment = .center
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        priceLabel.minimumScaleFactor = 0.5
        priceLabel.textColor = UIColor.darkGray
        priceLabel.backgroundColor = UIColor(named: "ColorGreen")
        priceLabel.layer.cornerRadius = 5
        priceLabel.layer.masksToBounds = true
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = WSFont.FontTypes.regular.font(withSize: 14)
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        dateLabel.minimumScaleFactor = 0.5
        dateLabel.textColor = WSColorPalette.fontColor
        
        contentView.addSubview(pictureImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(dateLabel)
        
        let views : [String:UIView] = ["pictureImageView":pictureImageView,"titleLabel":titleLabel,
                                       "priceLabel":priceLabel, "dateLabel": dateLabel]
        
        var allConstraints = [NSLayoutConstraint]()
        
        allConstraints += "V:|-16-[priceLabel(24)]-8-[titleLabel]-8-|".toConstraints(withViews: views)
        allConstraints += "V:|-16-[dateLabel]".toConstraints(withViews: views)
        allConstraints += "V:[pictureImageView(40)]->=16-|".toConstraints(withViews: views)
        allConstraints += "|-16-[pictureImageView(40)]-16-[titleLabel]-16-|".toConstraints(withViews: views)
        allConstraints += "|-16-[dateLabel]-16-[priceLabel]-16-|".toConstraints(withViews: views)
        
        NSLayoutConstraint.activate(allConstraints)
        
        let pictureImageViewCenterYConstraint = NSLayoutConstraint(item: pictureImageView!, attribute: .centerY, relatedBy: .equal, toItem: titleLabel, attribute: .centerY, multiplier: 1, constant:  0)
        contentView.addConstraint(pictureImageViewCenterYConstraint)
    }
}

class EventsListTableViewCellModel {
    var id: String
    var title: String
    var price: String
    var pictureURL: String
    var date: String
    
    init(currTitle: String, currPrice: String, currId: String, currPictureURL: String, currDate: String  ) {
        id = currId
        title = currTitle
        price = currPrice
        pictureURL = currPictureURL
        date = currDate
    }
}

