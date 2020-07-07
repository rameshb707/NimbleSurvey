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
    var worker = NimbleSurveyWorker()
    var surveyList: [Survey] = [Survey]() {
        didSet {
            if !surveyList.isEmpty {
                surveyListInPage.append((self.paginationIndex, surveyList))
                self.presenter?.presentSurveyList(pageNumber: paginationIndex, survey: surveyList)
                surveyList.removeAll()
            } else {
                presenter.stopLoadingIndicator()
            }
        }
    }
    
    // MARK: Properties
    var paginationIndex: Int = 1
    var surveyListInPage: [(Int, [Survey])]  = [(Int, [Survey])]()
    var fetchingNextPage: Bool = false
    
    let keyChainManager = KeyChainManager.sharedInstance
    
    /**
     Initially checks whether it is available in the temperory list.
         - If not it make new request to fetch the survey list by using valid accesstoken available in keychain.
        - if there is not token then it will request for new accesstoken
    */
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
            presenter?.stopLoadingIndicator()
        }
    }
    
    // MARK: Methods
    func getAccessToken() {
        let request = Request(parameters: .url(["username": "carlos@nimbl3.com", "grant_type": "password", "password": "antikera"]), endPoint: Constants.loginEndPoint, headers: nil, httpMethod: .POST)
        worker.getAccessToken(request: request) { [weak self] (accessToken, error) in
            guard let strongSelf = self else { return }
            strongSelf.handleAccessToken(accessToken: accessToken, error: error)
        }
    }
    
    /**
     Saves the new access token to the keychain
     */
    func handleAccessToken(accessToken: AccessToken?, error: Error?) {
        if let token = accessToken {
            let _ = self.keyChainManager.deleteExpiredToken()
            let saveToken: Bool = self.keyChainManager.saveToken(token: token.accesstoken, key: Constants.accessTokenKey)
            (saveToken) ? self.getSurveyList() : self.presenter.authenticationError()
        } else {
            self.presenter.authenticationError()
        }
    }
    
    func getListUsing(accessToken: String) {
        if let accessToken = keyChainManager.fetchToken(tokenKey: Constants.accessTokenKey) {
            let request = Request(parameters: .url(["page": "\(self.paginationIndex)", "per_page": "\(itemsPerPage)"]), endPoint: Constants.surveyEndPoint, headers: accessToken, httpMethod: .GET)
            worker.getSurveyList(request: request, completionHandler: { [weak self] (surveylist, response, error) in
                guard let strongSelf = self else { return }
                strongSelf.handledFetchedList(surveylist: surveylist, response: response, error: error)
            })
        }
    }
    
    /**
     Handles the fetched survey list from the server and gives it to presenter to present on the UI
     - If not the token might have been expired. so will get new access token and fetch again
     */
    func handledFetchedList( surveylist: [Survey]?, response: URLResponse?, error: Error?) {
        if let list  = surveylist {
            if !list.isEmpty {
                self.surveyList.append(contentsOf: list)
            } else {
                self.paginationIndex = (((self.fetchingNextPage) == true) ? ((self.paginationIndex) - 1) : (self.paginationIndex))
                self.presenter?.stopLoadingIndicator()
            }
        } else {
            if (response as? HTTPURLResponse)?.statusCode == 400 {
                self.getAccessToken()
            } else {
                self.paginationIndex = (((self.fetchingNextPage) == true) ? ((self.paginationIndex) - 1) : (self.paginationIndex))
                self.presenter?.surveyListFecthingError()
            }
        }
    }
}
