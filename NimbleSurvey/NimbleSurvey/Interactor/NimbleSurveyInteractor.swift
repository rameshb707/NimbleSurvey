//
//  NimbleSurveyInteractor.swift
//  NimbleSurvey
//
//  Created by Ramesh B on 04/07/20.
//  Copyright © 2020 Ramesh B. All rights reserved.
//

import Foundation

import UIKit

protocol NimbleSurveyInteractorInterface: class {
    func getSurveyList()
}

/// - Interactor which handles all the  bussiness logic and based on user interaction with view presenter ask interactor and interactor guides worker and reply back presneter to perform there duties
/// - Initially it checks the Database whether required data is available or not.
/// - If dat is avaliable it will ask presenter to display
/// - Else, it will ask worker to get the data form server
/// - Once the callback is recieved from the worker it will save it to database and then it tells presenter to display.
final class NimbleSurveyInteractor: NimbleSurveyInteractorInterface {
    
    weak var presenter: NimbelSurveyPresenterInterface!
    var surveyList: [Survey] = [Survey]() {
        didSet {
            self.presenter.getSurvey()
        }
    }
    
    /// Intitializes when it neccessary
    private lazy var networkManager: NetworkManager = {
        return NetworkManager()
    }()
    let keyChainManager = KeyChainManager.sharedInstance
    
    private func getAccessToken() {
        let request = Request(parameters: .url(["username": "carlos@nimbl3.com", "grant_type": "password", "password": "antikera"]), endPoint: Constants.loginEndPoint, headers: nil, httpMethod: .POST)
        networkManager.fetch(modelType: AccessToken.self, request, { [weak self] (accessToken, response, error) in
            if let token = accessToken as? AccessToken {
                let _ = self?.keyChainManager.deleteExpiredToken()
                let saveToken: Bool = self?.keyChainManager.saveToken(token: token.accesstoken, key: "NimbleAccessToken") ?? false
                (saveToken) ? self?.getSurveyList() : print("")
            } else {
            }
        })
    }
    
    func getSurveyList() {
        if let accessToken = keyChainManager.fetchToken(tokenKey: "NimbleAccessToken") {
            getListUsing(accessToken: accessToken)
        } else {
            getAccessToken()
        }
    }
    
    private func getListUsing(accessToken: String) {
        if let accessToken = keyChainManager.fetchToken(tokenKey: "NimbleAccessToken") {
            let request = Request(parameters: .url(["page": "1", "per_page": "1"]), endPoint: Constants.surveyEndPoint, headers: accessToken, httpMethod: .GET)
            networkManager.fetchList(modelType: Survey.self, request, {[weak self] (surveyList, response, error) in
                if let list  = surveyList as? [Survey] {
                    print(list)
                } else {
                    if (response as? HTTPURLResponse)?.statusCode == 400 {
                        self?.getAccessToken()
                    } else {
                        
                    }
                }
            })
        }
    }
}
