//
//  EditProfileTableViewController.swift
//  FellowBloggerV2
//
//  Created by Yaz Burrell on 3/21/19.
//  Copyright © 2019 Yaz Burrell. All rights reserved.
//

import UIKit
import Toucan
import Kingfisher

class EditProfileTableViewController: UITableViewController {
  
    @IBOutlet weak var editTableView: UITableView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var profileImageButton: CircularButton!
    
    public var bloggerInfo = [Blogger]()
    
    private var selectedImage: UIImage?
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        //ip.delegate = self
        return ip
    }()
    
    private var authservice = AppDelegate.authservice
    
    public var profileImage: UIImage!
    public var blogger: Blogger!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateProfileUI()
    }
    
    private func updateProfileUI() {
        profileImageButton.setImage(profileImage, for: .normal)
        //            coverImage.kf.setImage(with: URL(string: blogger.coverImageURL ?? "no image"), placeholder: #imageLiteral(resourceName: "placeholder-image"))
    }

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItem?.isEnabled = false
        guard let imageData = selectedImage?.jpegData(compressionQuality: 1.0),
            let user = authservice.getCurrentUser()
            else {
                showAlert(title: "Missing Fields", message: "A photo is  Required")
                return
        }
        StorageService.postImage(imageData: imageData, imageName: Constants.BlogImagePath + user.uid) { (error, imageUrl) in
            if let error = error {
                self.showAlert(title:"Error Saving Photo", message: error.localizedDescription)
            } else if let imageUrl = imageUrl {
                let request = user.createProfileChangeRequest()
                request.photoURL = imageUrl
                request.commitChanges(completion: { (error) in
                    if let error = error {
                        self.showAlert(title: "Error Saving Account Info", message: error.localizedDescription)
                    }
                })
                DBService.firestoreDB
                    .collection(BloggersCollectionKeys.CollectionKey)
                    .document(user.uid)
                    .updateData([BloggersCollectionKeys.PhotoURLKey  :  imageUrl.absoluteString], completion: { (error)
                        in
                        if let error = error {
                            self.showAlert(title: "Error Saving Account", message: error.localizedDescription)
                        }
                    })
                self.dismiss(animated: true)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }
    @IBAction func profileImageButtonPressed(_ sender: CircularButton) {
        var actionTitles = [String]()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionTitles = ["Photo Library", "Camera"]
        } else {
            actionTitles = ["Photo Library"]
        }
        showActionSheet(title: nil, message: nil, actionTitles: actionTitles, handlers: [{ [unowned self] photoLibraryAction in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
            }, { cameraAction in
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true)
            }
            ])
    }
   
 
}

//extension EditProfileTableViewController: UITableViewDataSource{
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return bloggerInfo.count
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BlogCell", for: indexPath) as? BlogCell else {
//            fatalError("BlogCell not found")
//        }
//        let blogger = bloggerInfo[indexPath.row]
//        cell.selectionStyle = .none
//        cell.bloggerImage.kf.setImage(with: URL(string: blogger.photoURL ?? "no image available"), placeholder: #imageLiteral(resourceName: "placeholder-image"))
//        
//        return cell
//    }
//    
//}
    


