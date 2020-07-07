//
//  NimbleSurveyTests.swift
//  NimbleSurveyTests
//
//  Created by Ramesh B on 03/07/20.
//  Copyright © 2020 Ramesh B. All rights reserved.
//

import XCTest
@testable import NimbleSurvey

class NimbleSurveyTests: XCTestCase {
    var nimbleSurveyViewController: NimbleSurveyViewController!

    override func setUp() {
        super.setUp()
        setUpViewController()
    }

    override func tearDown() {
        super.tearDown()
        nimbleSurveyViewController = nil
    }

    private func setUpViewController() {
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let navigation = storyboard.instantiateViewController(withIdentifier: "NavigationController") as? UINavigationController
        nimbleSurveyViewController = navigation?.topViewController as? NimbleSurveyViewController
         nimbleSurveyViewController.viewDidLoad()
         let _ = nimbleSurveyViewController?.view
         nimbleSurveyViewController?.viewWillAppear(false)
     }
    
    func testSurveyView() {
        XCTAssertNotNil(nimbleSurveyViewController.indexTableView)
        XCTAssertNotNil(nimbleSurveyViewController.nimbleSurveyCollectionView)
    }
    
    func testSurveyListInCollectionView() {
        let survey = [Survey(), Survey(), Survey()]
        nimbleSurveyViewController.surveyList.append(contentsOf: survey)
        XCTAssertTrue(nimbleSurveyViewController.nimbleSurveyCollectionView.numberOfItems(inSection: 0) == 3)
        XCTAssert(nimbleSurveyViewController.indexTableView.numberOfSections == 3)
    }
    
    func testSurveyPageContent() {
        let survey = [Survey(id: "q", title: "Nimble Survey", description: "description", cover_image_url: nil)]
        nimbleSurveyViewController.surveyList.append(contentsOf: survey)
        XCTAssertNotNil(nimbleSurveyViewController.nimbleSurveyCollectionView)

        XCTAssertTrue(nimbleSurveyViewController.nimbleSurveyCollectionView.numberOfItems(inSection: 0) == 1)
        XCTAssert(nimbleSurveyViewController.indexTableView.numberOfSections == 1)
    }
    
    func testFetchAccessToken() {
        let worker = NimbleSurveyWorker()
        let mindValleyMediaException = expectation(description: "Expected to media object")
           let request = Request(parameters: .url(["username": "carlos@nimbl3.com", "grant_type": "password", "password": "antikera"]), endPoint: Constants.loginEndPoint, headers: nil, httpMethod: .POST)
        worker.getAccessToken(request: request) { (accessToken, error) in
            XCTAssertNotNil(accessToken)
            mindValleyMediaException.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testFetchSurveyList() {
        let worker = NimbleSurveyWorker()
        let mindValleyMediaException = expectation(description: "Expected to media object")
        let accessTokenrequest = Request(parameters: .url(["username": "carlos@nimbl3.com", "grant_type": "password", "password": "antikera"]), endPoint: Constants.loginEndPoint, headers: nil, httpMethod: .POST)
        worker.getAccessToken(request: accessTokenrequest) { (accessToken, error) in
            let surveyRequest = Request(parameters: .url(["page": "\(1)", "per_page": "\(5)"]), endPoint: Constants.surveyEndPoint, headers: accessToken?.accesstoken!, httpMethod: .GET)
            worker.getSurveyList(request: surveyRequest) { (list, response, error) in
                XCTAssertNotNil(list)
                XCTAssert(list?.count == 5)
                mindValleyMediaException.fulfill()
                
            }
        }
        waitForExpectations(timeout: 30, handler: nil)
    }

    func testSurveyListTemperoryStore() {
        let interactor = NimbleSurveyInteractor()
        interactor.handledFetchedList(surveylist: [Survey()], response: nil, error: nil)
        XCTAssertFalse(interactor.surveyListInPage.isEmpty)
    }
    
    func testAccessToken() {
        let interactor = NimbleSurveyInteractor()
        let token = AccessToken(accesstoken: "testtoken12312312", tokenType: "Bearer", expiresIn: 7200, createdAt: 2122)
        interactor.handleAccessToken(accessToken: token, error: nil)
        let savedToken = KeyChainManager.sharedInstance.fetchToken(tokenKey: Constants.accessTokenKey)
        XCTAssert(savedToken == "testtoken12312312")
        XCTAssert(interactor.paginationIndex == 1)
        let _ = KeyChainManager.sharedInstance.deleteExpiredToken()
    }
    
    func testEmptySurvey() {
        let interactor = NimbleSurveyInteractor()
        interactor.handledFetchedList(surveylist: [], response: nil, error: nil)
        XCTAssert(interactor.paginationIndex == 1)
    }

    func testSurveyPagination() {
        let interactor = NimbleSurveyInteractor()
        interactor.getPreviousPageSurveyList()
        XCTAssert(interactor.paginationIndex == 1)
        
        interactor.getRefreshData()
        XCTAssertTrue(interactor.surveyList.isEmpty)
        XCTAssert(interactor.paginationIndex == 1)
        
        interactor.getNextPage()
        XCTAssertTrue(interactor.fetchingNextPage)
        XCTAssert(interactor.paginationIndex == 2)
    }
}
