//
//  LoadMoreView.swift
//  VKNews
//
//  Created by Тимур Шафигуллин on 14.10.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import UIKit

class LoadMoreView: UIView {

    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var loadMoreIndicator: UIActivityIndicatorView!
    
    class func instanceFromNib() -> LoadMoreView {
        return UINib(nibName: "LoadMoreView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LoadMoreView
    }

}
