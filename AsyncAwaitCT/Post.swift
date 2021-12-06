//
//  Post.swift
//  AsyncAwaitCT
//
//  Created by Russell Mirabelli on 12/5/21.
//

import Foundation

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

struct DeluxePost {
    let user: String
    let id: String
    let title: String
    let body: String
    
    init?(post: Post) {
        user = String(post.userId)
        id = String(post.id)
        title = post.title
        body = post.body
    }
}
