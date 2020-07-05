//
//  NimbleSurveyPresenter.swift
//  NimbleSurvey
//
//  Created by Ramesh B on 04/07/20.
//  Copyright © 2020 Ramesh B. All rights reserved.
//

import Foundation
/// The interface which helps to communicate between interactor and the view
protocol NimbelSurveyPresenterInterface: class {
    func getSurvey()
    func presentSurveyList(survey: [Survey])
}

/// The responsibility of this presenter is to listen from the user interaction and call interactor to perform bussines loic  and display the content which is avalibale from the interactor to view
class NimbleSurveyPresenter: NimbelSurveyPresenterInterface {
     weak var viewController: NimbleSurveyView!
     var interactor: NimbleSurveyInteractorInterface!
    
    func getSurvey() {
        interactor.getSurveyList()
    }
    
    func presentSurveyList(survey: [Survey]) {
        
    }
    
}
