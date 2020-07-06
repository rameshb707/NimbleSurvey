//
//  NimbleSurveyRouter.swift
//  NimbleSurvey
//
//  Created by Ramesh B on 06/07/20.
//  Copyright © 2020 Ramesh B. All rights reserved.
//

import Foundation
import UIKit

protocol NimbleSurveyRouterInterface {
    func navigateToTakeASurveyPage(navigationController: UINavigationController)
}

final class NimbleSurveyRouter: NimbleSurveyRouterInterface {
    func navigateToTakeASurveyPage(navigationController: UINavigationController) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let takeASurveyViewController = storyboard.instantiateViewController(withIdentifier: TakeASurveyViewController.identifier) as? TakeASurveyViewController {
            navigationController.pushViewController(takeASurveyViewController, animated: true)
        }
    }
}
