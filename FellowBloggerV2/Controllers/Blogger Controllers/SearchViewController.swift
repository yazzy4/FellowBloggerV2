//
//  SearchViewController.swift
//  FellowBloggerV2
//
//  Created by Yaz Burrell on 3/15/19.
//  Copyright © 2019 Yaz Burrell. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchProfileTableView: UITableView!
    @IBOutlet weak var profileSearchBar: UISearchBar!
    
    public var blogs = [Blog]() {
        didSet {
            DispatchQueue.main.async {
                self.searchProfileTableView.reloadData()
            }
        }
    }
    
    public var bloggers = [Blogger]() {
        didSet {
            DispatchQueue.main.async {
                self.searchProfileTableView.reloadData()
            }
        }
    }
    
    private var listener: ListenerRegistration!
    private var authservice = AppDelegate.authservice
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        searchProfileTableView.refreshControl = rc
        rc.addTarget(self, action: #selector(fetchBloggers), for: .valueChanged)
        return rc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchProfileTableView.dataSource = self
        searchProfileTableView.delegate = self
        searchProfileTableView.register(UINib(nibName: "SearchCell", bundle: nil), forCellReuseIdentifier: "SearchCell")
        profileSearchBar.delegate = self
        fetchBloggers()
    }
    
    @objc private func fetchBloggers() {
        refreshControl.beginRefreshing()
        listener = DBService.firestoreDB
            .collection(BloggersCollectionKeys.CollectionKey)
            .addSnapshotListener { [weak self] (snapshot, error) in
                if let error = error {
                    print("failed to fetch blogs with error: \(error.localizedDescription)")
                } else if let snapshot = snapshot {
                    self?.bloggers = snapshot.documents.map { Blogger(dict: $0.data()) }
                        .sorted { $0.bloggerId > $1.bloggerId }
                }
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bloggers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchProfileTableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        let profileToSet = bloggers[indexPath.row]
        guard let image = URL.init(string: profileToSet.photoURL!) else { return UITableViewCell()}
        do {
            let data = try Data.init(contentsOf: image)
            cell.imageView?.image = UIImage.init(data: data)
        } catch {
            print(error)
        }
        cell.textLabel?.text = profileToSet.fullName
        cell.detailTextLabel?.text = profileToSet.displayName
        //cell.imageView?.image = profileToSet.photoURL!
        return cell
    }
    
    
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.BloggerCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Show Blogger Profile", sender: indexPath)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else { return }
        bloggers = bloggers.filter { $0.fullName.contains(searchText) }
        bloggers = bloggers.filter { $0.displayName.contains(searchText) }
        searchBar.resignFirstResponder()
    }
}
