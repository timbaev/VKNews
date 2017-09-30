//
//  ViewController.swift
//  VKNews
//
//  Created by Тимур Шафигуллин on 29.09.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import UIKit
import VKSdkFramework

class ViewController: UIViewController, VKSdkDelegate {
    
    let scope = ["friends", "wall"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        VKSdk.initialize(withAppId: "6201081")
    }
    
    @IBAction func onLoginClick(_ sender: UIButton) {
        VKSdk.wakeUpSession(scope) { (_ state: VKAuthorizationState, _ error: Error?) -> Void in
            switch state {
            case .authorized:
                print("Authorized and ready to go")
                break
            case .initialized:
                VKSdk.authorize(self.scope)
                break
            case .error:
                print("Some error happend, but you may try later")
                break
            default:
                break
            }
        }
    }
    
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print("Okey, we getted API key")
        self.view.backgroundColor = UIColor.lightGray
        
    }
    
    func vkSdkUserAuthorizationFailed() {
        print("Oups..failed")
        self.view.backgroundColor = UIColor.red
    }

}

