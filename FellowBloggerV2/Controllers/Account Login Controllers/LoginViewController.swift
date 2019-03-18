//
//  LoginViewController.swift
//  FellowBloggerV2
//
//  Created by Yaz Burrell on 3/14/19.
//  Copyright © 2019 Yaz Burrell. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailLogin: UITextField!
    @IBOutlet weak var passwordLogin: UITextField!
    @IBOutlet weak var loginButton: NSLayoutConstraint!    
    @IBOutlet weak var newUserButton: UIButton!
    
    private var authService = AppDelegate.authservice
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        authService.authserviceExistingAccountDelegate = self

    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let email = emailLogin.text,
        !email.isEmpty,
        let password = passwordLogin.text,
        !password.isEmpty
        else {
            return
        }
        authService.signInExistingAccount(email: email, password: password)
        
    }
    

}

extension LoginViewController: AuthServiceExistingAccountDelegate {
    func didRecieveErrorSigningToExistingAccount(_ authservice: AuthService, error: Error) {
        showAlert(title: "Sign in Error", message: error.localizedDescription)
    }
    func didSignInToExistingAccount(_ authservice: AuthService, user: User) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "BloggersTabBarController") as! UITabBarController
        mainTabBarController.modalTransitionStyle = .crossDissolve
        mainTabBarController.modalPresentationStyle = .overFullScreen
        present(mainTabBarController, animated: true)
    }
}

