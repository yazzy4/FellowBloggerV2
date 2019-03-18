//
//  UIViewControllerExtension.swift
//  FellowBloggerV2
//
//  Created by Yaz Burrell on 3/15/19.
//  Copyright © 2019 Yaz Burrell. All rights reserved.
//

import UIKit

extension UIViewController {
    public func showLoginView() {
        if let _ = storyboard?.instantiateViewController(withIdentifier: "BloggersTabBarController") as? BloggersTabBarController {
            let loginViewStoryboard = UIStoryboard(name: "LoginView", bundle: nil)
            if let loginViewController = loginViewStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = UINavigationController(rootViewController: loginViewController)
            }
        } else {
            dismiss(animated: true)
        }
    }
}
