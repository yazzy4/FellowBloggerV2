//
//  ProfileViewController.swift
//  FellowBloggerV2
//
//  Created by Yaz Burrell on 3/15/19.
//  Copyright © 2019 Yaz Burrell. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
private lazy var profileHeaderView: ProfileHeaderView = {
        let headerView = ProfileHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 300))
        return headerView
    }()
    
    private let authservice = AppDelegate.authservice
    private var blogs = [Blog]() {
        didSet {
            DispatchQueue.main.async {
                self.profileTableView.reloadData()
            }
        }
    }
override func viewWillAppear(_ animated: Bool) {
super.viewWillAppear(true)
    //updateProfileUI()
        }
        
private func configureTableView() {
    profileTableView.tableHeaderView = profileHeaderView
    profileTableView.dataSource = self
    profileTableView.delegate = self
    profileTableView.register(UINib(nibName: "BlogCell", bundle: nil), forCellReuseIdentifier: "BlogCell")
        }
private func updateProfileUI() {
        guard let user = authservice.getCurrentUser() else {
            print("no logged user")
            return
        }
        DBService.fetchBlogCreator(userId: user.uid) { [weak self] (error, blogger) in
            if let _ = error {
                self?.showAlert(title: "Error fetching account info", message: error?.localizedDescription)
            } else if let blogger = blogger {
                self?.profileHeaderView.handleLabel.text = "@" + (blogger.displayName ?? "no display name")
                guard let photoURL = blogger.photoURL,
                    !photoURL.isEmpty else {
                        return
                        
                }
                
                self?.profileHeaderView.bloggerImageView.kf.setImage(with: URL(string: photoURL), placeholder: #imageLiteral(resourceName: "placeholder-image"))
                
            }
        }
    }
    
    private func fetchUserBlogs(){
        guard let user = authservice.getCurrentUser() else {
            print("no logged user")
            return
        }
        let _ = DBService.firestoreDB
            .collection(BlogsCollectionKeys.CollectionKey)
            .whereField(BlogsCollectionKeys.BloggerIdKey, isEqualTo: user.uid)
            .addSnapshotListener { [weak self] (snapshot, error) in
                if let error = error {
                    self?.showAlert(title: "Error fetching dishes", message: error.localizedDescription)
                } else if let snapshot = snapshot {
                    self?.blogs = snapshot.documents.map { Blog(dict: $0.data()) }
                        .sorted { $0.createdDate.date() > $1.createdDate.date() }        }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Edit Profile" {
            guard let navController = segue.destination as? UINavigationController,
                let editProfileVC = navController.viewControllers.first as? EditProfileViewController
                else {
                    fatalError("editProfileVC not found")
            }
            editProfileVC.profileImageView = profileHeaderView.profileImageView.image
            editProfileVC.displayName = profileHeaderView.displayNameLabel.text
        } else if segue.identifier == "Show Dish Details" {
            guard let indexPath = sender as? IndexPath,
                let cell = tableView.cellForRow(at: indexPath) as? DishCell,
                let dishDVC = segue.destination as? DishDetailViewController else {
                    fatalError("cannot segue to dishDVC")
            }
            let dish = dishes[indexPath.row]
            dishDVC.displayName = cell.displayNameLabel.text
            dishDVC.dish = dish
        }
    }
    
}

   
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
    }


extension ProfileViewController: UITableViewDelegate {
    
    }

extension ProfileViewController: ProfileHeaderViewDelegate {
    func willSignOut(_ profileHeaderView: ProfileHeaderView) {
        <#code#>
    }
    
    func willEditProfile(_ profileHeaderView: ProfileHeaderView) {
        <#code#>
    }
    
    
    }


