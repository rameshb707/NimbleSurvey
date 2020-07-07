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
    var parameters: APIParams? { get set} // Request Body/ Query Params
    var httpMethod: RequestType { get set }
    func getFullURL() -> String
    var headers: String? { get set}

}

// Contains supporting properties in order to construct the request. Its basically a request builder for the network call
struct Request: EndPoint {
    var parameters: APIParams?

    var endPoint: String
    
    var headers: String?

    var httpMethod: RequestType

    var baseURL: String {
        return Constants.baseURL
    }
    
    
    func getFullURL() -> String {
        if let prameter = self.parameters {
            return self.baseURL + endPoint + prameter.asString
        }
        return self.baseURL + endPoint
    }
}
