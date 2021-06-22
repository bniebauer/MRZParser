//
//  GitHubRequestController.swift
//  MRZParserApp
//
//  Created by Brenton Niebauer on 6/22/21.
//

import Foundation

struct UserData: Codable {
    let login: String
    let id: Int
    let html_url: String
}

struct SearchResult: Codable {
    let total_count: Int
    let incomplete_results: Bool
    let items: [UserData]
    
}

class GitHubRequestController {
    static let shared = GitHubRequestController()
    private let baseURLString = "https://api.github.com/search/users"
    
    func fetchUsers(matching query: [String: String], completion: @escaping (Result<[UserData], Error>) -> Void) {
        var urlComponents = URLComponents(string: baseURLString)!
        urlComponents.queryItems = query.map({ URLQueryItem(name: $0.key, value: $0.value) })
        
        let task = URLSession.shared.dataTask(with: urlComponents.url!) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let searchResult = try decoder.decode(SearchResult.self, from: data)
                    completion(.success(searchResult.items))
                } catch {
                    completion(.failure(error))
                }
            }
            
        }
        task.resume()
    }
}
