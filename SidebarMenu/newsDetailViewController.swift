//
//  NoticeDetailViewController.swift
//  nBulletin
//
//  Created by leading on 8/4/16.
//  Copyright © 2016 leading. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class newsDetailViewController: UIViewController {
    
    
    
    @IBOutlet weak var firstletter: UILabel!
    @IBOutlet weak var newsDetailMessage: UILabel!
    @IBOutlet var newsDetailTitle: UILabel! = UILabel()
    @IBOutlet weak var newsDetailDate: UILabel!
    @IBOutlet weak var newsDetailImage: UIImageView!
    
    var NewsData: newsTableViewController.datastruct?
    var atmsg:NSAttributedString?
    var date :String? = ""
    var imageurl: String? = ""
    var titlee: String? = "News Title"
    var messagee: NSAttributedString? = NSAttributedString(string: "News Body")
    //var IData = Notices.[NSManagedObject]()
    
    // var NoticeDetailData: Array < datastruct > = Array < datastruct >()
    
    @IBAction func sharebtn(_ sender: UIButton) {
        
        let textToShare = "\(newsDetailTitle.text!): \(newsDetailMessage.text!)\nsource: \(appname)"
        
        if let myWebsite = NSURL(string: "\(imageurl!)") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            //
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsDetailDate.text = NewsData?.updated_at
        atmsg = try! NSAttributedString(data: (NewsData?.message?.data(using: String.Encoding.unicode, allowLossyConversion: true)!)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil )
        newsDetailMessage.attributedText = atmsg//NSAttributedString(string:"test")//atmsg
      //  newsDetailImage.downl
        firstletter.text = newsDetailTitle.text?[0].uppercased()
        
        newsDetailTitle.text = NewsData?.title
        newsDetailTitle.numberOfLines = 0
        newsDetailTitle.sizeToFit()
       // loadImageFromUrl(imageurl , newsDetailImage)
        //newsDetailImage.al
        ///  NoticeDetailTitle.text = titlee//IData?.title// NoticeDetailData.title as? String
      ///  NoticeDetailTitle.numberOfLines = 0
      ///  NoticeDetailTitle.sizeToFit()
        // NoticeDetailMessage.
      ///  NoticeDetailMessage.attributedText = messagee
      ///  NoticeDetailMessage.sizeToFit()
        let url = URL(string: (NewsData?.image!)!)!
        newsDetailImage.af_setImage(withURL: url )

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
