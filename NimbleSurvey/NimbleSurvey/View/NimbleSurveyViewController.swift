//
//  NimbleSurveyViewController.swift
//  NimbleSurvey
//
//  Created by Ramesh B on 04/07/20.
//  Copyright © 2020 Ramesh B. All rights reserved.
//

import UIKit

protocol NimbleSurveyView :class{
    func displaySurvey(list: [Survey])
}
class NimbleSurveyViewController: UIViewController {

    var presenter: NimbelSurveyPresenterInterface!
    var surveyList: [Survey]  = [Survey]()
    override func viewDidLoad() {
        super.viewDidLoad()
        NimbleSurveyConfigurator.sharedInstance.configure(viewController: self)
        self.presenter.getSurvey()
    }

}

extension NimbleSurveyViewController: NimbleSurveyView {
    func displaySurvey(list: [Survey]) {
        self.surveyList.append(contentsOf: list)
    }
}
