//
//  NoticeDetailViewController.swift
//  nBulletin
//
//  Created by leading on 8/4/16.
//  Copyright © 2016 leading. All rights reserved.
//

import UIKit

class NoticeDetailViewController: UIViewController {
    
    
    
    @IBOutlet weak var noticeDateLabel: UILabel!
    @IBOutlet weak var firstletter: UILabel!
    @IBOutlet weak var NoticeDetailMessage: UILabel!
    @IBOutlet var NoticeDetailTitle: UILabel! = UILabel()
    
    var titlee: String? = ""
    var messagee: NSAttributedString? = NSAttributedString(string: "")
    //var IData = noticeViewController.datastruct()?//Notices.[NSManagedObject]()
    var NoticeData: noticeViewController.datastruct?
    var  attmsg: NSAttributedString?
   // var NoticeDetailData: Array < datastruct > = Array < datastruct >()
    
    @IBAction func sharebtn(_ sender: UIButton) {
        
         let textToShare = "\(NoticeDetailTitle.text!): \(NoticeDetailMessage.text!) (Source: \(appname))"
        
       // if let myWebsite = NSURL(string: "\(imageurl)") {
            let objectsToShare = [textToShare] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            //
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NoticeDetailTitle.text = NoticeData?.title//titlee//IData?.title// NoticeDetailData.title as? String
        NoticeDetailTitle.numberOfLines = 0
        NoticeDetailTitle.sizeToFit()
       // NoticeDetailMessage.
        firstletter.text = NoticeDetailTitle.text?[0].uppercased()
        NoticeDetailMessage.sizeToFit()
        attmsg = try! NSAttributedString(data: (NoticeData?.message?.data(using: String.Encoding.unicode, allowLossyConversion: true)!)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil )
        NoticeDetailMessage.attributedText = attmsg
        noticeDateLabel.text = NoticeData?.updated_at
        //NoticeDetailData.message as! String
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
