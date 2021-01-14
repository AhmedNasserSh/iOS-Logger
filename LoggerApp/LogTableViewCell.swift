//
//  LogTableViewCell.swift
//  LoggerApp
//
//  Created by Ahmed Nasser on 12/19/20.
//  Copyright © 2020 Instabug. All rights reserved.
//

import UIKit

class LogTableViewCell: UITableViewCell {

    @IBOutlet weak var logMessage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
