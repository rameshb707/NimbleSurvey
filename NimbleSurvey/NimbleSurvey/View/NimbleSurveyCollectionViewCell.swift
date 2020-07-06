//
//  NimbleSurveyCollectionViewCell.swift
//  NimbleSurvey
//
//  Created by Ramesh B on 05/07/20.
//  Copyright © 2020 Ramesh B. All rights reserved.
//

import UIKit
import Kingfisher
class NimbleSurveyCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: NimbleSurveyCollectionViewCell.self)
    
    @IBOutlet weak var sureveyTitle: UILabel!
    @IBOutlet weak var surveyDiscription: UILabel!
    @IBOutlet weak var surveyCoverImageView: UIImageView!
    
    func configureCell(survey: Survey) {
        sureveyTitle.text = survey.title
        surveyDiscription.text = survey.description
        if let coverImageUrl = survey.cover_image_url, let url = URL(string: coverImageUrl + "l") {
            surveyCoverImageView.kf.setImage(with: url)
        }
    }

}
