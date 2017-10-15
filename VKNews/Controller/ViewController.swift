//
//  ViewController.swift
//  VKNews
//
//  Created by Тимур Шафигуллин on 29.09.17.
//  Copyright © 2017 iOS Lab ITIS. All rights reserved.
//

import UIKit
import VKSdkFramework

class ViewController: UIViewController, VKSdkDelegate, VKSdkUIDelegate {

    let newsSegue = "newsSegue"
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 5
        
        if let sdk = VKSdk.initialize(withAppId: appID) {
            sdk.register(self)
            sdk.uiDelegate = self
        }
    }
    
    @IBAction func onLoginClick(_ sender: UIButton) {
        VKSdk.wakeUpSession(scope) { (_ state: VKAuthorizationState, _ error: Error?) -> Void in
            switch state {
            case .authorized:
                self.performSegue(withIdentifier: self.newsSegue, sender: nil)
                break
            case .initialized:
                VKSdk.authorize(scope)
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
        UserDefaults.standard.set(true, forKey: authorizedKey)
        
        let newsfeedController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: newsfeedControllerIdentifier)
        UIApplication.shared.delegate?.window??.rootViewController = newsfeedController
    }
    
    func vkSdkUserAuthorizationFailed() {
        print("Oups..failed")
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        present(controller, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        
    }

}

