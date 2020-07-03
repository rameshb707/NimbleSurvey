//
//  Reguest.swift
//  NimbleSurvey
//
//  Created by Ramesh B on 03/07/20.
//  Copyright © 2020 Ramesh B. All rights reserved.
//


import Foundation

protocol EndPoint {
    var baseURL: String { get } 
    var httpMethod: String { get }
    func getFullURL() -> String
}

// MARK: - Contains supporting properties in order to construct the request.
struct Request: EndPoint {
    var endPoint: String
    
    var baseURL: String {
        return Constants.baseURL
    }
    
    var httpMethod: String {
        return RequestType.GET.method
    }
    
    func getFullURL() -> String {
        return self.baseURL + endPoint
    }
}
