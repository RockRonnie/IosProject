//
//  QACell.swift
//  StrawberryPie
//
//  Created by iosdev on 10/12/2019.
//  Copyright © 2019 Team Työkkäri. All rights reserved.
//
// Reusable cell for QA. Has a .xib file for styling.


import UIKit

class QACell: UITableViewCell {
    @IBOutlet weak var QuestionField: UILabel!
    @IBOutlet weak var QuestionUser: UILabel!
    @IBOutlet weak var AnswerField: UILabel!
    @IBOutlet weak var AnswerUser: UILabel!
}
