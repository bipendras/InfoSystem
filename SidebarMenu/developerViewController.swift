//
//  developerViewController.swift
//  nBulletin
//
//  Created by leading on 10/3/16.
//  Copyright © 2016 leading. All rights reserved.
//

import UIKit

class developerViewController: UIViewController {

   
    @IBOutlet weak var menubtn: UIBarButtonItem!
    @IBOutlet weak var versionCode: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        menubtn.target = self.revealViewController()
        menubtn.action = #selector(SWRevealViewController.revealToggle(_:))
        
        // Do any additional setup after loading the view.
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.versionCode.text = "Version: \(version)"
        }
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
