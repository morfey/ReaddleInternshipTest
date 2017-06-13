//
//  WeekendMenu.swift
//  ReaddleInternshipTest
//
//  Created by  Tim on 13.06.17.
//  Copyright © 2017  Tim. All rights reserved.
//

import Foundation

class WeekendMenu {
    private let _dishes:[String]!
    
    
    var dishes : [String]{
        return _dishes
    }

    init (dishes: [String]){
        self._dishes = dishes
    }
}
