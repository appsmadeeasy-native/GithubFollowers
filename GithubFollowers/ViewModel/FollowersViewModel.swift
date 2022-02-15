//
//  FollowersViewModel.swift
//  GithubFollowers
//
//  Created by Syed Mahmud on 1/6/22.
//

import UIKit

class FollowersViewModel {
    
    var followers: [Follower] = []
    var user: User?
    private let client = GithubClient()
    
    func getGitFollowers(for username: String, handler: @escaping (Bool) -> Void ) {
        followers.removeAll()
        client.getGitFollowers(for: username) { [weak self] result in
            switch result {
            case .success(let followers):
                guard let followers = followers else {
                    return
                }
                self?.followers.append(contentsOf: followers)
                handler(true)
            case .failure(let error):
                print("the error \(error.localizedDescription)")
                handler(false)
            }
        }
    }
    
    func getUserDetails(for username: String, handler: @escaping (Bool) -> Void ) {
        
        client.getUserDetails(for: username) { [weak self] result in
            switch result {
            case .success(let user):
                guard let user = user else {
                    return
                }
                self?.user = user
                handler(true)
            case .failure(let error):
                print("the error \(error)")
                handler(false)
            }
        }
    }
    
    func downloadUserImage(for imageURL: String, completion: @escaping (Result<UIImage?, APIError>) -> Void) {
        
        client.downloadUserImage(for: imageURL) { result in
            switch result {
            case .success(let image):
                guard let image = image else {
                    return
                }
                completion(Result.success(image))
            case .failure(let error):
                print("the error \(error)")
                completion(Result.failure(error))
            }
        }
    }
}
    

