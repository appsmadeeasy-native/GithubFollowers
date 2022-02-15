//
//  GithubClient.swift
//  GithubFollowers
//
//  Created by Syed Mahmud on 1/14/22.
//

import UIKit

class GithubClient: RemoteAPIClient {
    
    var session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func getGitFollowers(for username: String, completion: @escaping (Result<[Follower]?, APIError>) -> Void) {
        
        let endpoint = GithubEndpoint(urlBase: "https://api.github.com",
                                      urlPath: "/users/\(username)/followers",
                                      queryItem: "per_page=200")
        
        fetch(with: endpoint.request, decode: { json -> [Follower]? in
            guard let json = json as? [Follower] else {
                return nil
            }
            return json
        }, completion: completion)
    }
    
    func getUserDetails(for username: String, completion: @escaping (Result<User?, APIError>) -> Void) {
        
        let endpoint = GithubEndpoint(urlBase: "https://api.github.com",
                                      urlPath: "/users/\(username)",
                                      queryItem: "")
        
        fetch(with: endpoint.request, decode: { json -> User? in
            guard let json = json as? User else {
                return nil
            }
            return json
        }, completion: completion)
    }
    
    func downloadUserImage(for imageURL: String, completion: @escaping (Result<UIImage?, APIError>) -> Void) {
        
        guard let url = URL(string: imageURL) else {
            return
        }
        
        let imageTask = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                      completion(.failure(.responseUnsuccessful))
                      return
                  }
            completion(Result.success(image))
        }
        imageTask.resume()
    }
}
