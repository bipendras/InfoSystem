//
//  resourceTableViewCell.swift
//  nBulletin
//
//  Created by beependra on 2/14/17.
//  Copyright © 2017 Leading Professional Technology. All rights reserved.
//

import UIKit

class resourceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellTitle: UILabel!
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
