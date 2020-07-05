//
//  URLRequestExtension.swift
//  NimbleSurvey
//
//  Created by Ramesh B on 03/07/20.
//  Copyright © 2020 Ramesh B. All rights reserved.
//


import Foundation

extension URLRequest {
    
    init(request: Request) {
        self.init(url: URL.init(string: request.getFullURL())!)
        httpMethod = request.httpMethod.method
        if let headerValue = request.headers {
            self.setValue(Constants.tokenType + headerValue, forHTTPHeaderField: "Authorization")
        }
    }
}
