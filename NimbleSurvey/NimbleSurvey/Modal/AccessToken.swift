//
//  AccessToken.swift
//  NimbleSurvey
//
//  Created by Ramesh B on 03/07/20.
//  Copyright © 2020 Ramesh B. All rights reserved.
//

import Foundation

struct AccessToken: Codable {
    var accesstoken: String?
    var tokenType: String?
    var expiresIn: Double?
    var createdAt: Double?
    
    enum CodingKeys: String, CodingKey {
        case accesstoken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case createdAt = "created_at"
    }
}
