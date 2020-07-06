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
    func getNextPage()
    func getRefreshData()
    func getPreviousPageSurveyList()
}

/// - Interactor which handles all the  bussiness logic and based on user interaction with view presenter ask interactor and interactor guides worker and reply back presneter to perform there duties
/// - Initially it checks the Database whether required data is available or not.
/// - If dat is avaliable it will ask presenter to display
/// - Else, it will ask worker to get the data form server
/// - Once the callback is recieved from the worker it will save it to database and then it tells presenter to display.
final class NimbleSurveyInteractor: NimbleSurveyInteractorInterface {
    
    weak var presenter: NimbelSurveyPresenterInterface!
    private var paginationIndex: Int = 1
    private var surveyListInPage: [(Int, [Survey])]  = [(Int, [Survey])]()
    private var fetchingNextPage: Bool = false
    var surveyList: [Survey] = [Survey]() {
        didSet {
            if !surveyList.isEmpty {
                surveyListInPage.append((self.paginationIndex, surveyList))
                self.presenter.presentSurveyList(pageNumber: paginationIndex, survey: surveyList)
                surveyList.removeAll()
            } else {
                presenter.stopLoadingIndicator()
            }
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
                let saveToken: Bool = self?.keyChainManager.saveToken(token: token.accesstoken, key: Constants.accessTokenKey) ?? false
                (saveToken) ? self?.getSurveyList() : print("")
            } else {
            }
        })
    }
    
    func getSurveyList() {
        let existSurveyList =  surveyListInPage.filter { $0.0 == paginationIndex }
        if existSurveyList.isEmpty {
            if let accessToken = keyChainManager.fetchToken(tokenKey: "NimbleAccessToken") {
                getListUsing(accessToken: accessToken)
            } else {
                getAccessToken()
            }
        } else {
            if let list = existSurveyList.first?.1 {
                self.presenter.presentSurveyList(pageNumber: paginationIndex, survey: list)
            }
        }
    }
    
    private func getListUsing(accessToken: String) {
        if let accessToken = keyChainManager.fetchToken(tokenKey: Constants.accessTokenKey) {
            let request = Request(parameters: .url(["page": "\(self.paginationIndex)", "per_page": "\(Constants.itemsPerPage)"]), endPoint: Constants.surveyEndPoint, headers: accessToken, httpMethod: .GET)
            networkManager.fetchList(modelType: Survey.self, request, {[weak self] (surveylist, response, error) in
                if let list  = surveylist as? [Survey] {
                    if !list.isEmpty {
                        self?.surveyList.append(contentsOf: list)
                    } else {
                        self?.paginationIndex = (((self?.fetchingNextPage) == true) ? ((self?.paginationIndex)! - 1) : (self?.paginationIndex))!
                        self?.presenter.stopLoadingIndicator()
                    }
                } else {
                    if (response as? HTTPURLResponse)?.statusCode == 400 {
                        self?.getAccessToken()
                    } else {
                        self?.paginationIndex = (((self?.fetchingNextPage) == true) ? ((self?.paginationIndex)! - 1) : (self?.paginationIndex))!
                    }
                }
            })
        }
    }
    
    func getNextPage() {
        paginationIndex += 1
        fetchingNextPage = true
        getSurveyList()
    }
    
    func getRefreshData() {
        surveyListInPage.removeAll()
        paginationIndex = 1
        getSurveyList()
    }
    
    func getPreviousPageSurveyList() {
        if paginationIndex > 1 {
            paginationIndex -= 1
            getSurveyList()
        } else {
            paginationIndex = 1
            presenter.stopLoadingIndicator()
        }
    }
}
