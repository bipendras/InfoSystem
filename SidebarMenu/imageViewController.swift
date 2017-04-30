//
//  imageViewController.swift
//  nBulletin
//
//  Created by beependra on 2/18/17.
//  Copyright © 2017 Leading Professional Technology. All rights reserved.
//

import UIKit

class imageViewController: UIViewController {

    @IBOutlet weak var scroller: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        scroller.auk.show(url: "https://www.gstatic.com/webp/gallery3/1.png")
        scroller.auk.show(url: "https://www.gstatic.com/webp/gallery3/3_webp_a.png")
        scroller.auk.startAutoScroll(delaySeconds: 3)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
