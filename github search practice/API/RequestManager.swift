//
//  APIEngine.swift
//  github search practice
//
//  Created by Paul.Chou on 2020/2/11.
//  Copyright © 2020 Paul.Chou. All rights reserved.
//

import Foundation

fileprivate let hostURL = "https://api.github.com"
fileprivate let searchPath = "/search/users"

class RequestManager {
    private var session: URLSession!
    
    init() {
        session = URLSession(configuration: URLSessionConfiguration.default)
    }
}

extension RequestManager {
    func fetchUsers(_ userName: String, page: Int? = nil, completionHandler: @escaping (Result<(Data, Int?), Error>) -> Void)  {
        
        guard let url = URL(string: "\(hostURL)\(searchPath)?q=\(userName)&page=\(page ?? 1)") else {
            assertionFailure("should have url")
            return
        }
        
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 15.0)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
            } else if let data = data {
                if let httpURLResponse = response as? HTTPURLResponse,
                    let links = httpURLResponse.allHeaderFields["Link"] as? String {
                    completionHandler(.success((data, self.getNextPageNumber(headerLinks: links))))
                } else {
                    completionHandler(.success((data, nil)))
                }
            } else {
                assertionFailure("Should not get here")
            }
        }
        
        task.resume()
    }
}

private extension RequestManager {
    
    func getNextPageNumber(headerLinks: String) -> Int? {
        let links = headerLinks.components(separatedBy: ",")
        
        let dictionary = links.reduce([:], { (partialResult, link) -> [String: String] in
            var result = partialResult
            let components = link.components(separatedBy:"; ")
            let cleanPath = components[0].trimmingCharacters(in: CharacterSet(charactersIn: " <>"))
            result[components[1]] = cleanPath
            return result
        })
        if let nextPagePath = dictionary["rel=\"next\""],
            let urlComponents = URLComponents(string: nextPagePath),
            let queryItems = urlComponents.queryItems,
            let page = queryItems.first(where: { $0.name == "page" })?.value {
            return Int(page)
        } else {
            return nil
        }
    }
}
