//
//  Category.swift
//  StrawberryPie
//
//  Created by iosdev on 22/11/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//

import Foundation

class category {
    
    private let categoryName: String?
    private let categorySummary: String?
    
    init(categoryName: String, categorySummary: String) {
        self.categoryName = categoryName
        self.categorySummary = categorySummary
    }
}
