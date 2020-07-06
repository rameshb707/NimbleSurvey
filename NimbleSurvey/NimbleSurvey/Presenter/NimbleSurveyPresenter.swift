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
    func presentSurveyList(pageNumber: Int,survey: [Survey])
    func fetchMoreData()
    func fetchNewDataByRefresh()
    func fetchPreviousData()
    func stopLoadingIndicator()
}

/// The responsibility of this presenter is to listen from the user interaction and call interactor to perform bussines loic  and display the content which is avalibale from the interactor to view
class NimbleSurveyPresenter: NimbelSurveyPresenterInterface {
     weak var viewController: NimbleSurveyView!
     var interactor: NimbleSurveyInteractorInterface!
    
    func getSurvey() {
        interactor.getSurveyList()
        viewController.startLoadingIndicator()
    }
    
    func fetchMoreData() {
        interactor.getNextPage()
        viewController.startLoadingIndicator()
    }

    func fetchPreviousData() {
        interactor.getPreviousPageSurveyList()
        viewController.startLoadingIndicator()
    }
    
    func presentSurveyList(pageNumber: Int,survey: [Survey]) {
        DispatchQueue.main.async {
            self.viewController.displaySurvey(pageNumber: pageNumber, list: survey)
            self.viewController.stopLoadingIndicator()
        }
    }
    
    func fetchNewDataByRefresh() {
        DispatchQueue.main.async {
            self.interactor.getRefreshData()
            self.viewController.startLoadingIndicator()
        }
    }
    
    func stopLoadingIndicator(){
        DispatchQueue.main.async {
            self.viewController.stopLoadingIndicator()
        }
    }
}
