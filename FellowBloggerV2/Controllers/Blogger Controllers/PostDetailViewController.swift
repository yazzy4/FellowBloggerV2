//
//  PostDetailViewController.swift
//  FellowBloggerV2
//
//  Created by Yaz Burrell on 3/15/19.
//  Copyright © 2019 Yaz Burrell. All rights reserved.
//

import UIKit


class PostDetailViewController: UIViewController {
    
    @IBOutlet weak var bloggerImageView: CircularImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var bloggerHandleLabel: UILabel!
    @IBOutlet weak var blogDescriptionLabel: UILabel!
    
    public var blog: Blog!
    public var blogger: Blogger!
    public var displayName: String?
    
    private let authservice = AppDelegate.authservice
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //updateUI()
       updateUsernameAndImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateUI()
    }
    
    
    private func updateUI(){
        postImageView.kf.setImage(with: URL(string: blog.imageURL), placeholder: #imageLiteral(resourceName: "placeholder-image"))
        bloggerHandleLabel.text = (displayName ?? "no username")
        blogDescriptionLabel.text = blog.blogDescription
        
        
        
    }
    
    func updateUsernameAndImage(){
        guard let user = authservice.getCurrentUser() else {
            print("no logged user")
            return
        }
        DBService.fetchBlogCreator(userId: blog.bloggerId) { [weak self] (error, blogger) in
            if let error = error {
                self?.showAlert(title: "Error fetching username", message: error.localizedDescription)
            } else if let blogger = blogger {
                self?.bloggerHandleLabel.text = "@" + (blogger.displayName ?? "no display name")
            }
            guard let photoURL = blogger?.photoURL,
                !photoURL.isEmpty else {
                    return
            }
            self?.bloggerImageView.kf.setImage(with: URL(string: photoURL), placeholder: #imageLiteral(resourceName: "placeholder-image"))
            
        }
        
    }
        
   
    

    
@IBAction func unwindFromEditBlogView(segue: UIStoryboardSegue) {
        let editVC = segue.source as! EditPostViewController
        blogDescriptionLabel.text = editVC.editBlogDescriptionTextView.text
    }
    
    @IBAction func moreInfoButtonPressed(_ sender: UIButton) {
        guard let user = authservice.getCurrentUser() else {
            print("no logged user")
            return
    }
    
    
    
    }

}
