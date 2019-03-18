//
//  ViewController.swift
//  FellowBloggerV2
//
//  Created by Yaz Burrell on 3/14/19.
//  Copyright © 2019 Yaz Burrell. All rights reserved.
//

import UIKit


class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var enterEmail: UITextField!
    @IBOutlet weak var enterPassword: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var returnToLoginButton: UIButton!
    
    private var authservice = AppDelegate.authservice
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authservice.authserviceCreateNewAccountDelegate = self

    }

    @IBAction func createAccountButtonPressed(_ sender: Any) {
        guard let username = username.text,
            !username.isEmpty,
            let email = enterEmail.text,
            !email.isEmpty,
            let password = enterPassword.text,
            !password.isEmpty
            else {
                return
        }
          authservice.createNewAccount(username: username, email: email, password: password)
        
    }
    
    @IBAction func returnToLoginButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)

    }
    
}

extension CreateAccountViewController: AuthServiceCreateNewAccountDelegate {
    func didRecieveErrorCreatingAccount(_ authservice: AuthService, error: Error) {
        showAlert(title: "Account Creation Error", message: error.localizedDescription)
    }
    
    func didCreateNewAccount(_ authservice: AuthService, blogger: Blogger) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "BloggersTabBarController") as! UITabBarController
        mainTabBarController.modalTransitionStyle = .crossDissolve
        mainTabBarController.modalPresentationStyle = .overFullScreen
        present(mainTabBarController, animated: true)
    }
}


