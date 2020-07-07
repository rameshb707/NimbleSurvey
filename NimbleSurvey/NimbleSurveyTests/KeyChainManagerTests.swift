//
//  KeyChainManagerTests.swift
//  NimbleSurveyTests
//
//  Created by Ramesh B on 06/07/20.
//  Copyright © 2020 Ramesh B. All rights reserved.
//

import XCTest
@testable import NimbleSurvey

class KeyChainManagerTests: XCTestCase {

    func testKeyChainSave() throws {
        let savekeychain = KeyChainManager.sharedInstance.saveToken(token: "Access32e6783e67286", key: "AccessToken")
        XCTAssertTrue(savekeychain)
        
        let saveEmptykeychain = KeyChainManager.sharedInstance.saveToken(token: nil, key: "AccessToken")
        XCTAssertFalse(saveEmptykeychain)

        let _ = KeyChainManager.sharedInstance.deleteExpiredToken()
    }
    
    func testKeyChainFetch() throws {
        let _ = KeyChainManager.sharedInstance.saveToken(token: "Access32e6783e67286", key: "AccessToken")
        let accessToken = KeyChainManager.sharedInstance.fetchToken(tokenKey: "AccessToken")
        XCTAssert(accessToken == "Access32e6783e67286")
        let _ = KeyChainManager.sharedInstance.deleteExpiredToken()
    }

}
