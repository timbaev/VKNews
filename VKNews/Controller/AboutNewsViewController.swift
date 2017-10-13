//
//  AboutNewsViewController.swift
//  VKNews
//
//  Created by Тимур Шафигуллин on 07.10.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import UIKit
import Kingfisher

class AboutNewsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var contentScrollView: UIScrollView!
    @IBOutlet weak var contentStackView: UIStackView!
    
    let imageCellIdentifier = "imageCell"
    var news: News!
    var source: Source!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareController()
        if news.imagesURL.count == 0 {
            collectionView.isHidden = true
        }
    }
    
    private func prepareController() {
        avatarImageView.roundCorners()
        avatarImageView.kf.setImage(with: source.photoURL)
        
        if let profile = source as? Profile {
            nameLabel.text = "\(profile.name) \(profile.surname)"
        } else if let group = source as? Group {
            nameLabel.text = group.name
        }
        textLabel.text = news.text
    }

    //MARK: - CollectionView methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.imagesURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let imageHeight:CGFloat = 150
        return CGSize(width: collectionView.bounds.size.width, height: imageHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellIdentifier, for: indexPath) as! ImageCollectionViewCell
        
        cell.photoImageView.kf.setImage(with: news.imagesURL[indexPath.row])
        
        return cell
    }

}
