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
    @IBOutlet weak var coverImage: UIButton!
    @IBOutlet weak var profileImageButton: CircularButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var bioTextLabel: UILabel!
    
    
    public var bloggerInfo = [Blogger]()
    public var bloggers: Blogger?
    
    private var selectedImage: UIImage?
    private var selectedCoverImage: UIImage?

    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    private var authservice = AppDelegate.authservice
    
    public var profileImage: UIImage!
    public var coverImageView: UIImage!
    public var isSelected = false

    public var blogger: Blogger!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //editTableView.dataSource = self
        updateProfileUI()
    }
    
    private func configureTableView() {
        editTableView.dataSource = self
        editTableView.delegate = self
        editTableView.register(UINib(nibName: "BlogCell", bundle: nil), forCellReuseIdentifier: "BlogCell")
    }
    
    private func updateProfileUI() {
        profileImageButton.setImage(profileImage, for: .normal)
        coverImage.setImage(coverImageView, for: .normal)
        selectedImage = profileImageButton.imageView?.image
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
        StorageService.postImage(imageData: imageData, imageName: Constants.ProfileImagePath + user.uid) { (error, imageUrl) in
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
        guard let coverImageData = selectedCoverImage?.jpegData(compressionQuality: 1.0)
            else {
                showAlert(title: "Missing Fields", message: "A photo is  Required")
                return
        }
        StorageService.postImage(imageData: coverImageData, imageName: Constants.CoverPhotoImagePath + user.uid) { (error, coverUrl) in            if let error = error {
            self.showAlert(title:"Error Saving Photo", message: error.localizedDescription)
            } else if let coverUrl = coverUrl {
                let request = user.createProfileChangeRequest()
                request.photoURL = coverUrl
                request.commitChanges(completion: { (error) in
                    if let error = error {
                        self.showAlert(title: "Error Saving Account Info", message: error.localizedDescription)
                    }
                })
                DBService.firestoreDB
                    .collection(BloggersCollectionKeys.CollectionKey)
                    .document(user.uid)
                    .updateData([BloggersCollectionKeys.CoverImageURLKey  :  coverUrl.absoluteString], completion: { (error)
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
    @IBAction func profileImageButtonPressed() {
        isSelected = true
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
   
    @IBAction func coverPhotoButtonPressed(_ sender: UIButton) {
        isSelected = false
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
    


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//
//        }
    }

extension EditProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("original image not available")
            return
        }
        let size = CGSize(width: 500, height: 500)
        let resizedImage = Toucan.Resize.resizeImage(originalImage, size: size)
        if isSelected {
            selectedImage = resizedImage
            profileImageButton.setImage(resizedImage, for: .normal)
            } else {
            selectedCoverImage = resizedImage
            coverImage.setImage(resizedImage, for: .normal)
        }
        dismiss(animated: true)
        }
        
}


    




