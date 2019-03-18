//
//  ProfileView.swift
//  FellowBloggerV2
//
//  Created by Yaz Burrell on 3/15/19.
//  Copyright © 2019 Yaz Burrell. All rights reserved.
//

import UIKit

protocol ProfileHeaderViewDelegate: AnyObject {
    func willSignOut(_ profileHeaderView: ProfileHeaderView)
    func willEditProfile(_ profileHeaderView: ProfileHeaderView)
}

class ProfileHeaderView: UIView {

    @IBOutlet weak var coverPhoto: UIImageView!
    @IBOutlet weak var bloggerImageView: CircularImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var editButtonPressed: UIButton!
    @IBOutlet weak var signoutButtonPressed: UIButton!
    
    
}
