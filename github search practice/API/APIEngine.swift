//
//  APIEngine.swift
//  github search practice
//
//  Created by Paul.Chou on 2020/2/11.
//  Copyright © 2020 Paul.Chou. All rights reserved.
//

import Foundation

protocol SearchUser {
    func users(userName: String, page: Int?, completionHandler: @escaping (Result<([User], Int?), Error>) -> Void)
}

class APIEngine {
    private lazy var requestManager = RequestManager()
}

extension APIEngine: SearchUser {
    func users(userName: String, page: Int? = nil, completionHandler: @escaping (Result<([User], Int?), Error>) -> Void) {
        requestManager.fetchUsers(userName, page: page) { (result) in
            switch result {
            case .success(let (data, nextPageNumber)):
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let response = try decoder.decode(APIResponseObject<User>.self, from: data)
                    completionHandler(.success((response.items, nextPageNumber)))
                } catch {
                    completionHandler(.failure(error))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
