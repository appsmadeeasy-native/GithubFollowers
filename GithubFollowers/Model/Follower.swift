//
//  Follower.swift
//  GithubFollowers
//
//  Created by Syed Mahmud on 1/6/22.
//

import Foundation

struct Follower: Decodable, Encodable, Hashable {
    var login: String
    var avatarUrl: String
}
