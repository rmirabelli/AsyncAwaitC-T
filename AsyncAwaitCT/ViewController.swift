//
//  ViewController.swift
//  AsyncAwaitCT
//
//  Created by Russell Mirabelli on 12/5/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    let service = PostsService()
    var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        Task {
            do {
                    let posts = try await service.posts()
                    self.posts = posts
                    self.tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.item]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = post.title
        cell.detailTextLabel?.text = post.body
        return cell
    }
    
    
}
