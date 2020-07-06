//
//  NimbleSurveyCollectionViewCell.swift
//  NimbleSurvey
//
//  Created by Ramesh B on 05/07/20.
//  Copyright © 2020 Ramesh B. All rights reserved.
//

import UIKit
import Kingfisher


protocol OnClickSurveyDelegate: class {
    func takeASurvey()
}

class NimbleSurveyCollectionViewCell: UICollectionViewCell {

    // MARK: Properties
    static let identifier = String(describing: NimbleSurveyCollectionViewCell.self)
    
    // MARK: Outlets
    @IBOutlet weak var sureveyTitle: UILabel!
    @IBOutlet weak var surveyDiscription: UILabel!
    @IBOutlet weak var surveyCoverImageView: UIImageView!
    
    weak var delegate: OnClickSurveyDelegate?
    
    /// Configures the cell from the survey object entity
    func configureCell(survey: Survey) {
        sureveyTitle.text = survey.title
        surveyDiscription.text = survey.description
        if let coverImageUrl = survey.cover_image_url, let url = URL(string: coverImageUrl + "l") {
            surveyCoverImageView.kf.setImage(with: url)
        }
    }
    
    @IBAction func takeASurvey(_ sender: Any) {
        delegate?.takeASurvey()
    }
    
}
