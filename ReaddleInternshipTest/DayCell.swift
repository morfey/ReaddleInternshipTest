//
//  DayCell.swift
//  ReaddleInternshipTest
//
//  Created by  Tim on 13.06.17.
//  Copyright © 2017  Tim. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell {
    
    @IBOutlet weak var dayNameLbl: UILabel!
    @IBOutlet weak var firstLbl: UILabel!
    
    func configureCell () {
        dayNameLbl.text = "Monday"
        firstLbl.text = "Soup"
    }
    
}
