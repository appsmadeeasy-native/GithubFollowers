//
//  User.swift
//  GithubFollowers
//
//  Created by Syed Mahmud on 1/6/22.
//

import Foundation

struct User: Decodable {
    var login: String
    var avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    var publicRepos: Int
    var publicGists: Int
    var htmlUrl: String
    var following: Int
    var followers: Int
    var createdAt: Date
}
