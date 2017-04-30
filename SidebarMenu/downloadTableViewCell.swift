//
//  downloadTableViewCell.swift
//  nBulletin
//
//  Created by leading on 9/13/16.
//  Copyright © 2016 leading. All rights reserved.
//

import UIKit

class downloadTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var celldate: UILabel!
    @IBOutlet weak var cellDatee: UILabel!
    @IBOutlet weak var cellsize: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
