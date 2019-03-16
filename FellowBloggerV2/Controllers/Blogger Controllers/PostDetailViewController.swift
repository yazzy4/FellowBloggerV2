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
    @IBOutlet weak var blogDescriptionTextView: UITextView!
    
    public var blog: Blog!
    public var displayName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func moreInfoButtonPressed(_ sender: UIButton) {
    }
    
    

}
