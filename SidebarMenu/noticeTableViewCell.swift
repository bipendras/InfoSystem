//
//  noticeTableViewCell.swift
//  nBulletin
//
//  Created by leading on 9/12/16.
//  Copyright © 2016 leading. All rights reserved.
//

import UIKit

class noticeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellSubtitle: UILabel!
    @IBOutlet weak var celldate: UILabel!
    @IBOutlet weak var cellDatee: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
