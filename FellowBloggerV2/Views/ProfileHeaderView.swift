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

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var coverPhoto: UIButton!
    @IBOutlet weak var bloggerImageView: CircularButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!

 
    
    weak var delegate: ProfileHeaderViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ProfileHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        delegate?.willSignOut(self)
    }
    
    @IBAction func editButtonPresseds(_ sender: UIButton) {
        delegate?.willEditProfile(self)
    }
    
}
