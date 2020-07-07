//
//  NimbleSurveyConfigurator.swift
//  NimbleSurvey
//
//  Created by Ramesh B on 04/07/20.
//  Copyright © 2020 Ramesh B. All rights reserved.
//

import Foundation
import UIKit

/// It helps to configure the required refrences which is neccessary
final class NimbleSurveyConfigurator {
  
    // MARK: - Object lifecycle
    static let sharedInstance = NimbleSurveyConfigurator()

    // MARK: - Configuration
    func configure(viewController: NimbleSurveyViewController) {
        
        let presenter = NimbleSurveyPresenter()
        viewController.presenter = presenter
        presenter.viewController = viewController
        
        let interactor = NimbleSurveyInteractor()
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        let router = NimbleSurveyRouter()
        presenter.router = router
    }
}
