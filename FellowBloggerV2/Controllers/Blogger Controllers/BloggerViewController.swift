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

class BloggerViewController: UIViewController {
    
    @IBOutlet weak var bloggerTableView: UITableView!
    private var blogs = [Blog]() {
        didSet{
            DispatchQueue.main.async {
                self.bloggerTableView.reloadData()
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "Show Blog Details" {
//            guard let indexPath = sender as? IndexPath,
//                let cell = bloggerTableView.cellForRow(at: indexPath) as? BlogCell,
//                let blogDVC = segue.destination as? PostDetailViewController else {
//                    fatalError("cannot segue to dishDVC")
//            }
//            let blog = blogs[indexPath.row]
//
//        }
//    }

}

extension BloggerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BlogCell", for: indexPath) as? BlogCell else {
            fatalError("BlogCell not found")
        }
        let blog = blogs[indexPath.row]
        cell.selectionStyle = .none
        cell.bloggerImage.kf.setImage(with: URL(string: blog.bloggerId), placeholder: #imageLiteral(resourceName: "placeholder-image.png"))
        cell.blogDescriptionLabel.text = blog.blogDescription
        cell.createdAtLabel.text = blog.createdDate
        cell.postImage.kf.indicatorType = .activity
        cell.postImage.kf.setImage(with: URL(string: blog.imageURL), placeholder: #imageLiteral(resourceName: <#T##String#>))
        

//        fetchDishCreator(userId: dish.userId, cell: cell, dish: dish)
        return cell
    }
    
//    private func fetchDishCreator(userId: String, cell: DishCell, dish: Dish) {
//        DBService.fetchDishCreator(userId: userId) { (error, dishCreator) in
//            if let error = error {
//                print("failed to fetch dish creator with error: \(error.localizedDescription)")
//            } else if let dishCreator = dishCreator {
//                cell.displayNameLabel.text = "@" + dishCreator.displayName
//            }
//        }
//    }
}
