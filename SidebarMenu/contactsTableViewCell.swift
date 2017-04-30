//
//  contactsTableViewCell.swift
//  nBulletin
//
//  Created by leading on 9/14/16.
//  Copyright © 2016 leading. All rights reserved.
//

import UIKit

class contactsTableViewCell: UITableViewCell {
    @IBOutlet weak var cellName: UILabel!
    @IBOutlet weak var cellNo: UILabel!

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellEmail: UILabel!
    @IBOutlet weak var cellDesignation: UILabel!
     override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func callActn(sender: AnyObject) {
        let url:NSURL = NSURL(string: "tel:\\\(cellNo.text)")!
        
          UIApplication.shared.openURL(url as URL)
        
    }
    @IBAction func emailActn(sender: AnyObject) {
        let url:NSURL = NSURL(string: "mailto:\(cellEmail.text)")!
        
        UIApplication.shared.openURL(url as URL)
        
    }
}
