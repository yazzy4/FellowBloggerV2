//
//  AddPostViewController.swift
//  FellowBloggerV2
//
//  Created by Yaz Burrell on 3/15/19.
//  Copyright © 2019 Yaz Burrell. All rights reserved.
//

import UIKit
import Toucan

class AddPostViewController: UIViewController {
    
    @IBOutlet weak var blogDescriptionTextField: UITextView!
    @IBOutlet weak var blogImage: UIImageView!
    
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    private var selectedImage: UIImage?
    private var authservice = AppDelegate.authservice
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextView()
    }
    
    private func configureTextView() {
        configureInputAccessoryView()
        blogDescriptionTextField.delegate = self
        blogDescriptionTextField.textColor = .lightGray
        blogDescriptionTextField.text = Constants.BlogDescriptionPlaceholder
    }
    
    private func configureInputAccessoryView() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
        blogDescriptionTextField.inputAccessoryView = toolbar
        let cameraBarItem = UIBarButtonItem(barButtonSystemItem: .camera,
                                            target: self,
                                            action: #selector(cameraButtonPressed))
        let photoLibraryBarItem = UIBarButtonItem(title: "Photo Library",
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(photoLibraryButtonPressed))
        let flexibleSpaceBarItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [cameraBarItem, flexibleSpaceBarItem, photoLibraryBarItem]
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraBarItem.isEnabled = false
        }
    }
    
    @objc func cameraButtonPressed() {
        imagePickerController.sourceType = .camera
        present(imagePickerController, animated: true)
    }
    
    @objc func photoLibraryButtonPressed() {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    
    
    @IBAction func postButtonPressed(_ sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItem?.isEnabled = false
        guard let blogDescription = blogDescriptionTextField.text,
            !blogDescription.isEmpty,
            let imageData = selectedImage?.jpegData(compressionQuality: 1.0) else {
                print("missing fields")
                return
        }
        guard let user = authservice.getCurrentUser() else {
            print("no logged user")
            return
        }
        let docRef = DBService.firestoreDB
            .collection(BlogsCollectionKeys.CollectionKey)
            .document()
        StorageService.postImage(imageData: imageData,
        imageName: Constants.BlogImagePath + "\(user.uid)/\(docRef.documentID)") { [weak self] (error, imageURL) in
            if let error = error {
                print("fail to post iamge with error: \(error.localizedDescription)")
                    } else if let imageURL = imageURL {
                print("image posted and recieved imageURL - post blog to database: \(imageURL)")
                let blog = Blog(createdDate: Date.getISOTimestamp(), bloggerId: user.uid, imageURL: imageURL.absoluteString, blogDescription: blogDescription,documentId: docRef.documentID)
        DBService.postBlog(blog: blog)
            if let error = error {
                self?.showAlert(title: "Posting Blog Error", message: error.localizedDescription)
                    } else {
                    self?.showAlert(title: "Blog Posted", message: "Looking forward to all of your valuable insights") { action in
            self?.dismiss(animated: true)
                        }
                    }
            }
            self?.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }


extension AddPostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Constants.BlogDescriptionPlaceholder {
            textView.text = ""
            textView.textColor = .black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = Constants.BlogDescriptionPlaceholder
            textView.textColor = .lightGray
        }
    }
}

extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("original image is nil")
            return
        }
        let resizedImage = Toucan.init(image: originalImage).resize(CGSize(width: 500, height: 500))
        selectedImage = resizedImage.image
        blogImage.image = resizedImage.image
        dismiss(animated: true)
    }
}

    


