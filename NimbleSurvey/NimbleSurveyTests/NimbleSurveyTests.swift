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
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        setUpViewController()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
    
    func testExample() {
       
    }

}
