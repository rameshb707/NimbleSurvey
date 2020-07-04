//
//  NetworkManager.swift
//  NimbleSurvey
//
//  Created by Ramesh B on 03/07/20.
//  Copyright © 2020 Ramesh B. All rights reserved.
//


import Foundation

typealias resultCompletion = (T: Codable?, URLResponse?, Error?)


/// All the network managers should conform to this Protocol
protocol NetworkRequest: class {
    
    /**
    Schedules request operation

    - Parameters:
       - modelType: Operation object to be scheduled
       - Request: The network request that needs to be executed
       - completionHandler: A callback that is called on the completion of API call

    */
    func fetch<T>(modelType: T.Type,_ request: Request, _ completion: @escaping (resultCompletion) -> Void) where T : Codable
    
    /**
    Schedules request operation for the list of Modal

    - Parameters:
       - modelType: Operation object to be scheduled
       - Request: The network request that needs to be executed
       - completionHandler: A callback that is called on the completion of API call

    */
    func fetchList<T: Codable>(modelType: T.Type,_ request: Request, _ completion: @escaping (resultCompletion) -> Void)
}


/// This class maintains Schedule network request and fire tasks
class NetworkManager: NetworkRequest {
    
    // The shares seesion used to executr the task
    let session = URLSession.shared
    
   /**
    Schedules request operation

    - Parameters:
       - modelType: Operation object to be scheduled
       - Request: The network request that needs to be executed
       - completionHandler: A callback that is called on the completion of API call

    */
    func fetch<T: Codable>(modelType: T.Type,_ request: Request, _ completion: @escaping (resultCompletion) -> Void) {
        
        let dataRequest = URLRequest(request: request)

        let task = session.dataTask(with: dataRequest, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let err = error {
                completion((nil, nil, err))
                return
            }
            guard let productData = data else { completion((nil, nil, nil)); return; }
            do {
                let value = try JSONDecoder().decode(T.self, from: productData)
                completion((value, nil, nil))
            } catch let err {
                completion((nil,nil, err))
            }
        })
        task.resume()
    }
    
    func fetchList<T: Codable>(modelType: T.Type,_ request: Request, _ completion: @escaping (resultCompletion) -> Void) {
        
        let dataRequest = URLRequest(request: request)

        let task = session.dataTask(with: dataRequest, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let err = error {
                completion((nil, nil, err))
                return
            }
            guard let productData = data else { completion((nil, nil, nil)); return; }
            do {
                let value = try JSONDecoder().decode([T].self, from: productData)
                completion((value, nil, nil))
            } catch let err {
                completion((nil,nil, err))
            }
        })
        task.resume()
    }
}
