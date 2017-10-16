//
//  MessageAlert.swift
//  VKNews
//
//  Created by Тимур Шафигуллин on 16.10.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(with title: String?, message: String?) {
        let okay = "Хорошо"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okay, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
