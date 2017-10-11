//
//  NewsTestTableViewCell.swift
//  VKNews
//
//  Created by Тимур Шафигуллин on 12.10.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textNewsLabel: UILabel!
    @IBOutlet var photoImageViews: [UIImageView]!
    @IBOutlet weak var moreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.roundCorners()
        
        let originalImage = moreButton.image(for: .normal)
        let tintedImage = originalImage?.withRenderingMode(.alwaysTemplate)
        moreButton.setImage(tintedImage, for: .normal)
        moreButton.tintColor = .darkGray
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func prepareCell(with news: News, with source: Source) {
        
        if let profile = source as? Profile {
            nameLabel.text = "\(profile.name) \(profile.surname)"
        } else if let group = source as? Group {
            nameLabel.text = group.name
        }
        
        dateLabel.text = Date().offset(from: news.date)
        textNewsLabel.text = news.text
    }

}
