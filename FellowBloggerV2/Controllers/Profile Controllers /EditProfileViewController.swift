//
//  EditProfileViewController.swift
//  FellowBloggerV2
//
//  Created by Yaz Burrell on 3/15/19.
//  Copyright © 2019 Yaz Burrell. All rights reserved.
//

import UIKit
import Toucan

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var profileImageButton: CircularButton!
 
   
    public var blogger: Blogger!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func profileButtonPressed(_ sender: CircularButton) {
    }
    
    
}
