//
//  APIResponseObject.swift
//  github search practice
//
//  Created by Paul.Chou on 2020/2/11.
//  Copyright © 2020 Paul.Chou. All rights reserved.
//

import Foundation

struct APIResponseObject<item: Codable>: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [item]
}
