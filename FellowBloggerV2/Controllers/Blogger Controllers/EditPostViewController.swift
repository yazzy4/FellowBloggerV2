//
//  EditPostViewController.swift
//  FellowBloggerV2
//
//  Created by Yaz Burrell on 3/15/19.
//  Copyright © 2019 Yaz Burrell. All rights reserved.
//

import UIKit

class EditPostViewController: UIViewController {
    
    @IBOutlet weak var editBlogDescriptionTextView: UITextView!
    
    public var blog: Blog!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI(){
        editBlogDescriptionTextView.text = blog.blogDescription
    }

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItem?.isEnabled = false
        guard let description = editBlogDescriptionTextView.text,
            !description.isEmpty else {
                showAlert(title: "Missing Fields", message: "Must enter text")
                return
        }
        DBService.firestoreDB
        .collection(BlogsCollectionKeys.CollectionKey)
        .document(blog.documentId)
            .updateData([BlogsCollectionKeys.BlogDescritionKey : description ]) {  (error) in
                if let error = error {
                    self.showAlert(title: "Editing Error", message: error.localizedDescription)
                }
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.performSegue(withIdentifier: "Unwind From Edit Blog", sender: self)
            }
                
        }
        
    }
    


