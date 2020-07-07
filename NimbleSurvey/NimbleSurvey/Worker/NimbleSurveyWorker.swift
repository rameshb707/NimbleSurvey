//
//  NimbleSurveyWorker.swift
//  NimbleSurvey
//
//  Created by Ramesh B on 07/07/20.
//  Copyright © 2020 Ramesh B. All rights reserved.
//


import Foundation

// As the name suggest it has to do work by calling the API from network manager and send the call back to interactor
 class NimbleSurveyWorker {
    
    // Intitializes when it neccessary
    private lazy var networkManager: NetworkManager = {
        return NetworkManager()
    }()

    /// This intercepts the authentication challenge and fetches the valid access token
     ///
     /// - Parameters:
     ///   - request: Hold the neccessay thhings to make a server request
     ///   - completionHandler: The block that provides the Access Token to the interactor
    func getAccessToken(request: Request, completionHandler: @escaping (AccessToken?, Error?) -> ()) {
        networkManager.fetch(modelType: AccessToken.self, request, {
            (accessToken, response, error) in
            completionHandler(accessToken as? AccessToken, error)
        })
    }
    
    /// This fetches the survey list from the valid access token
     ///
     /// - Parameters:
     ///   - request: Hold the neccessay thhings to make a server request
     ///   - completionHandler: The block that provides survey list which requested per page
    func getSurveyList(request: Request, completionHandler: @escaping ([Survey]?, URLResponse?, Error?) -> ()) {
          networkManager.fetchList(modelType: Survey.self, request, { (surveylist, response, error) in
            completionHandler(surveylist as? [Survey], response, error)
        })
    }
}
