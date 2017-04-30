//
//  NewsTableViewCell.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 Leading Professional Technology. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var celldot: UIImageView!
    @IBOutlet weak var cellimage: UIImageView!
    @IBOutlet weak var celltitle: UILabel!
    @IBOutlet weak var celldatee: UILabel!
    @IBOutlet weak var celldate: UILabel!
    @IBOutlet weak var cellsubtitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
