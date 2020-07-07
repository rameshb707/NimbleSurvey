//
//  RequestType.swift
//  NimbleSurvey
//
//  Created by Ramesh B on 03/07/20.
//  Copyright © 2020 Ramesh B. All rights reserved.
//


import Foundation

enum RequestType {
    case GET
    case POST
}

// MARK: - Contains supporting Computed properties
extension RequestType {
    
    /// returns: the http method as string
    var method: String {
        switch self {
            case .GET: return "GET"
            case .POST: return "POST"

        }
    }
}

enum APIParams {
    case url([String:String])
}

extension APIParams {
    
    var asString: String {
        switch self {
        case let .url(parameter):
            return parameter.asQueryString
        }
    }
}

extension Dictionary {
    
    // This computes the asString and appends as parameter for the baseurl to create the request
    var asQueryString: String {
        
        let encodedString = reduce("") { (result, content) in
            var previous_query = result
            if !previous_query.isEmpty {
                previous_query.append("&\(content.key)=\(content.value)")
            } else {
                previous_query.append("?\(content.key)=\(content.value)")
            }
            return previous_query
        }
        
        return encodedString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? encodedString
        
    }
}
