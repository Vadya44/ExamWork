//
//  myTableViewCell.swift
//  ExamWork
//
//  Created by Вадим Гатауллин on 25/03/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import UIKit

class myTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var subnameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(human: Human) {
        self.nameLabel.text = human.name
        self.surnameLabel.text = human.surname
        self.subnameLabel.text = human.subsurName
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
