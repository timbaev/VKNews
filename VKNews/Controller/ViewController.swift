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
        if self.isInternetAvailable() {
            VKSdk.wakeUpSession(scope) { (_ state: VKAuthorizationState, _ error: Error?) -> Void in
                switch state {
                case .authorized:
                    self.performSegue(withIdentifier: self.newsSegue, sender: nil)
                    break
                case .initialized:
                    VKSdk.authorize(scope)
                    break
                case .error:
                    self.showAlert(with: "Ошибка авторизации", message: "Проверьте интернет подключение. Попробуйте еще раз.")
                    break
                default:
                    break
                }
            }
        } else {
            self.showAlert(with: "Нет соединения!", message: "Отсутствует интернет подключение")
        }
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        UserDefaults.standard.set(true, forKey: authorizedKey)
        
        let newsfeedController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: newsfeedControllerIdentifier)
        UIApplication.shared.delegate?.window??.rootViewController = newsfeedController
    }
    
    func vkSdkUserAuthorizationFailed() {
        self.showAlert(with: "Что-то пошло не так", message: "Не удаось авторизовать вас на сервере")
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        present(controller, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        
    }

}

