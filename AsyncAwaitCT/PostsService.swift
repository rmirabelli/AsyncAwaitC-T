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
    
    func posts() async throws -> [DeluxePost] {
        guard let url = URL(string: urlString) else { throw PostError.badURL }
        let session = URLSession(configuration: .ephemeral)
        let (data, response) = try await(session.data(from: url))
        guard let response = response as? HTTPURLResponse else { throw PostError.badResponse }
        guard response.statusCode == 200 else { throw PostError.badResponse }
        let posts = try JSONDecoder().decode([Post].self, from: data)
        let deluxe = try await transform(posts)
        return deluxe
    }
    
    func expensiveTransform(posts: [Post], completion: @escaping ([DeluxePost]) -> Void) {
        let deluxePosts = posts.map { DeluxePost(post: $0) }
        completion(deluxePosts.compactMap {$0})
    }

    func transform(_ posts: [Post]) async throws -> [DeluxePost] {
        let deluxe = posts.compactMap { DeluxePost(post: $0) }
        return deluxe
    }
    
}
