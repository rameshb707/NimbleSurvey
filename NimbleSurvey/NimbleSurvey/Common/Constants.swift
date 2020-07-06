//
//  Constants.swift
//  MindValley
//
//  Created by Ramesh B on 24/6/2563 BE.
//  Copyright © 2563 Ramesh B. All rights reserved.
//

import UIKit

struct Constants {
    
    static let baseURL: String = "https://nimble-survey-api.herokuapp.com"
    static let loginEndPoint: String = "/oauth/token"
    static let surveyEndPoint: String = "/surveys.json"
    static let tokenType: String = "Bearer "
    static let accessTokenKey: String = "NimbleAccessToken"
    static let indexTableViewHeight: CGFloat = 20
    static let tableViewFootterHeight: CGFloat = 5
    static let itemsPerPage: Int = 10

}

