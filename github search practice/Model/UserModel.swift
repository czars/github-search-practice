//
//  UserModel.swift
//  github search practice
//
//  Created by Paul.Chou on 2020/2/11.
//  Copyright © 2020 Paul.Chou. All rights reserved.
//

import Foundation

struct User: Codable, Hashable {
    let ID: Int
    let URL: String
    let name: String
    let nodeId: String
    let avatarUrl: String
    let gravatarId: String
    
    enum CodingKeys: String, CodingKey {
        case ID = "id"
        case URL = "url"
        case name = "login"
        case nodeId
        case avatarUrl
        case gravatarId
    }
    
    
}
