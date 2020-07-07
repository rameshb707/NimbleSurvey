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

    func getAccessToken(request: Request, completionHandler: @escaping (AccessToken?, Error?) -> ()) {
        networkManager.fetch(modelType: AccessToken.self, request, {
            (accessToken, response, error) in
            completionHandler(accessToken as? AccessToken, error)
        })
    }
    
    func getSurveyList(request: Request, completionHandler: @escaping ([Survey]?, URLResponse?, Error?) -> ()) {
          networkManager.fetchList(modelType: Survey.self, request, { (surveylist, response, error) in
            completionHandler(surveylist as? [Survey], response, error)
        })
    }
}
