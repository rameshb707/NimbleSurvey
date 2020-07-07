//
//  TakeASurveyViewController.swift
//  NimbleSurvey
//
//  Created by Ramesh B on 06/07/20.
//  Copyright © 2020 Ramesh B. All rights reserved.
//

import UIKit

class TakeASurveyViewController: UIViewController {
    static let identifier = String(describing: TakeASurveyViewController.self)

    @IBOutlet weak var surveyItemsCountTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let itemsPerPageNumber = surveyItemsCountTextfield.text, let itemsPerPageNumberCount = Int(itemsPerPageNumber) {
            itemsPerPage = itemsPerPageNumberCount
        }
    }
}
