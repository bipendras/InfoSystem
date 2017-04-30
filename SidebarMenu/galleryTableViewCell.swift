//
//  imageTableViewCell.swift
//  gallerytest
//
//  Created by beependra on 12/25/16.
//  Copyright © 2016 beependra. All rights reserved.
//


import UIKit

class galleryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
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
