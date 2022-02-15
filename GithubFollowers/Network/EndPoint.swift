//
//  EndPoint.swift
//  GithubFollowers
//
//  Created by Syed Mahmud on 1/13/22.
//

import Foundation

protocol Endpoint {
    
    var base: String { get }
    var path: String { get }
    var queryItems: String { get }
}

extension Endpoint {
    
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        components.query = queryItems
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url)
    }
}

struct GithubEndpoint: Endpoint {
    
    var base: String
    var path: String
    var queryItems: String
    
    init(urlBase: String, urlPath: String, queryItem: String) {
        base = urlBase
        path = urlPath
        queryItems = queryItem
    }
}
