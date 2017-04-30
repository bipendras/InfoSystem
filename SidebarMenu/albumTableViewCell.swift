//
//  albumTableViewCell.swift
//  nBulletin
//
//  Created by beependra on 2/14/17.
//  Copyright © 2017 Leading Professional Technology. All rights reserved.
//

import UIKit

class albumTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellUpdated: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
