//
//  BloggerViewController.swift
//  FellowBloggerV2
//
//  Created by Yaz Burrell on 3/15/19.
//  Copyright © 2019 Yaz Burrell. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class BlogViewController: UIViewController {
    
    @IBOutlet weak var bloggerTableView: UITableView!
    public var blogs = [Blog]() {
        didSet{
            DispatchQueue.main.async {
                self.bloggerTableView.reloadData()
            }
        }
    }
    
   
    public var bloggers = [Blogger]() {
        didSet {
            DispatchQueue.main.async {
                
            }
        }
    }
    
    
    private var listener: ListenerRegistration!
    private var authservice = AppDelegate.authservice
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        bloggerTableView.refreshControl = rc
        rc.addTarget(self, action: #selector(fetchBlogs), for: .valueChanged)
        return rc
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bloggerTableView.dataSource = self
        bloggerTableView.delegate = self
        bloggerTableView.register(UINib(nibName: "BlogCell", bundle: nil), forCellReuseIdentifier: "BlogCell")
        fetchBlogs()
        
        
    }
    
    @objc private func fetchBlogs() {
        refreshControl.beginRefreshing()
        listener = DBService.firestoreDB
            .collection(BlogsCollectionKeys.CollectionKey)
            .addSnapshotListener { [weak self] (snapshot, error) in
                if let error = error {
                    print("failed to fetch dishes with error: \(error.localizedDescription)")
                } else if let snapshot = snapshot {
                    // anytime there is a modified change to the database our table view updates
                    self?.blogs = snapshot.documents.map { Blog(dict: $0.data()) }
                        .sorted { $0.createdDate.date() > $1.createdDate.date() }
                }
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
        }
    }
    
   

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Blog Details" {
            guard let indexPath = sender as? IndexPath,
                let cell = bloggerTableView.cellForRow(at: indexPath) as? BlogCell,
                let blogDVC = segue.destination as? PostDetailViewController else {
                    fatalError("cannot segue to blogDVC")
            }
            let blog = blogs[indexPath.row]
            //blogDVC.displayName = cell.blogDescriptionLabel.text
            blogDVC.blog = blog
        
        }
        
    }

}

extension BlogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BlogCell", for: indexPath) as? BlogCell else {
            fatalError("BlogCell not found")
        }
        let blog = blogs[indexPath.row]
        cell.selectionStyle = .none
        cell.blogDescriptionLabel.text = blog.blogDescription
        cell.createdAtLabel.text = blog.createdDate
        cell.postImage.kf.indicatorType = .activity
        cell.postImage.kf.setImage(with: URL(string: blog.imageURL), placeholder: #imageLiteral(resourceName: "placeholder-image.png"))
//        cell.bloggerImage.kf.setImage(with: URL(string: blog.documentId), placeholder: #imageLiteral(resourceName: "placeholder-image.png"))
        fetchBlogCreator(userId: blog.bloggerId, cell: cell, blog: blog)
        
        return cell
    }
    
    private func fetchBlogCreator(userId: String, cell: BlogCell, blog: Blog) {
        DBService.fetchBlogCreator(userId: userId) { (error, blogger) in
            if let error = error {
                print("failed to fetch blog creator with error: \(error.localizedDescription)")
            } else if let blogger = blogger {
                cell.bloggerImage.kf.setImage(with: URL(string: blogger.photoURL ?? "no image"))
            }
        }
    }
}
extension BlogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.BlogCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Show Blog Details", sender: indexPath)
        
    
       
    }
}

extension BlogViewController: AuthServiceSignOutDelegate  {
    func didSignOut(_ authservice: AuthService) {
        listener.remove()
        showLoginView()
    }
    func didSignOutWithError(_ authservice: AuthService, error: Error) {}
}
