//
//  EditBioViewController.swift
//  FellowBloggerV2
//
//  Created by Yaz Burrell on 3/20/19.
//  Copyright © 2019 Yaz Burrell. All rights reserved.
//

import UIKit

class EditBioViewController: UIViewController {
    
    @IBOutlet weak var bioTextView: UITextView!
    
    public var blog: Blog!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItem?.isEnabled = false
        guard let description = bioTextView.text,
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
                self.performSegue(withIdentifier: "Edit Blog", sender: self)
        }
        
    }
}
