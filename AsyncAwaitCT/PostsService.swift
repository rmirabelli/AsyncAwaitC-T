//
//  PostsService.swift
//  AsyncAwaitCT
//
//  Created by Russell Mirabelli on 12/5/21.
//

import Foundation
import UIKit

enum PostError: Error {
    case badURL
    case badResponse
    case noData
    case decodingError
}

struct PostsService {
    private let urlString = "https://jsonplaceholder.typicode.com/posts"
    
    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let url = URL(string: urlString) else { completion(.failure(PostError.badURL)); return}
        let session = URLSession(configuration: .ephemeral)
        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil else { completion(.failure(error!)); return}
            guard let response = response as? HTTPURLResponse else {completion(.failure(PostError.badResponse)); return}
            guard response.statusCode == 200 else { completion(.failure(PostError.badResponse)); return}
            guard let data = data else { completion(.failure(PostError.noData)); return}
            guard let posts = try? JSONDecoder().decode([Post].self, from: data) else {completion(.failure(PostError.decodingError)); return}
            completion(.success(posts))
        }
        task.resume()
    }
}
