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
//        guard let user = authservice.getCurrentUser() else {
//            print("no logged user")
//            return
//        }
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
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let saveImageAction = UIAlertAction(title: "Save Image", style: .default) { [unowned self] (action) in
            if let image = self.postImageView.image {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }
            let editAction = UIAlertAction(title: "Edit", style: .default) { [unowned self] (action) in
                self.showEditView()
            }
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [unowned self] (action) in
                self.confirmDeletionActionSheet(handler: { (action) in
                    self.executeDelete()
                })
            }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(saveImageAction)
        if user.uid == blog.bloggerId {
            alertController.addAction(editAction)
            alertController.addAction(deleteAction)
        }
        
        alertController.addAction(cancelAction)
        present(alertController, animated: true)

    }
    private func executeDelete() {
        DBService.deleteBlog(blog: blog) { [weak self] (error) in
            if let error = error {
                self?.showAlert(title: "Error deleting blog", message: error.localizedDescription)
            } else {
                self?.showAlert(title: "Deleted successfully", message: nil, handler: { (action) in
                    self?.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Edit Blog" {
            guard let navController = segue.destination as? UINavigationController,
                let editVC = navController.viewControllers.first as? EditPostViewController else {
                    fatalError("failed to segue to editVC")
            }
            editVC.blog = blog
        }
    }
    
    private func showEditView() {
        performSegue(withIdentifier: "Show Edit Blog", sender: nil)
    }
}
