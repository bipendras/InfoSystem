//
//  dashboardViewController.swift
//  nBulletin
//
//  Created by beependra on 4/7/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import SystemConfiguration
import Alamofire
import TTGSnackbar

class dashboardViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var diaryBtn: UIButton!
    @IBOutlet weak var leaveBtn: UIButton!
    @IBOutlet weak var inboxBtn: UIButton!
    @IBOutlet weak var slider: UIScrollView!
    @IBOutlet weak var profileBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        diaryBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        inboxBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        profileBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        leaveBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            revealViewController().rightViewRevealWidth = 150
//            extraButton.target = revealViewController()
//            extraButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
//            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
            
        }
        
        //slider.auk.removeAll()
        slider.auk.removeAll()
        
        slider.auk.settings.placeholderImage = UIImage(named: "aiabg")
        slider.auk.settings.preloadRemoteImagesAround = 1
        slider.auk.settings.contentMode = .scaleAspectFill
        //slider.auk.autoscroll.startAutoScroll(slider, delaySeconds: 2, forward: true, cycle: true, animated: true, auk: slider.auk)
        Moa.settings.cache.requestCachePolicy = .returnCacheDataElseLoad
        
        getSlider()
       slider.auk.startAutoScroll(delaySeconds: 2)
        // Do any additional setup after loading the view.
    }

    func getSlider(){
        
        
        
//            let parameters = [
//                //            "name" : data.value(forKey: "name") as! String,
//                //            "email" : data.value(forKey: "username") as! String,
//                //            "subject" : subject,
//                //            "phone" : data.value(forKey: "phone") as! String,
//                //            "message" : message
//                // "date" : result
//                
//            ]
            let requestString = noticeurl
            print(requestString)
            
            // Both calls are equivalent
            Alamofire.request(requestString, method: .get, encoding: JSONEncoding.default).responseJSON {
                response in //debugPrint(response)
                
                // print(response.request)  // original URL request
                // print(response.response) // HTTP URL response
                //print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    
                    if    let list = JSON as? NSDictionary// NSArray
                    {
                        if let error:Bool = list["error"] as? Bool{
                            if error == false {
                                // print(datadef.object(forKey: "datadic"))
                                // _ = self.navigationController?.popViewController(animated: true)
                                //let snackbar = TTGSnackbar.init(message: list["msg"] as! String, duration: .middle)
                              //  snackbar.show()
                                let slidr: NSArray = list["slider"] as! NSArray
                                for sliders in slidr{
                                    let sldrs = sliders as! NSDictionary
                                    if let imgg = sldrs["image_thumb"] as? String {
                                        self.slider.auk.show(url: imgg)
                                        
                                    }
                                    else{
                                        
                                    }
                                    
                                    
                                }
                            }
                            else{
                                print("noauth")
                                
                                let snackbar = TTGSnackbar.init(message: list["msg"] as! String, duration: .middle)
                                snackbar.show()
                            }
                            
                        }
                        else{
                            //success = false
                            
                            
                            let snackbar = TTGSnackbar.init(message: "Server Error", duration: .middle)
                            snackbar.show()
                            
                        }
                    }
                    
                }
                else{
                    let snackbar = TTGSnackbar.init(message: "Unable to Connect to Server", duration: .middle)
                    snackbar.show()
                    
                }
            }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //fetch()
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            // clearCoreData("Noticeentity")
            // notish.removeAll()
            self.edgesForExtendedLayout = []
         //   loadnoticefromcoredata()
            //   clearCoreData(entity: "Notice")
            //loadnoticefromcoredata()
            
          //  loadnoticefromurl()
            
            /*    print(notis)
             TableData.removeAll()
             clearCoreData("Noticeentity")
             n.loadnoticess()
             print(notis)
             tableView.reloadData()
             print(TableData)
             // do_table_refresh()
             */
        } else {
            print("Internet connection FAILED")
            let alert = UIAlertController(title: "No Internet Connection", message: "Please make sure your device is connected to the Internet", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default){ action in
                
            })
            UIApplication.shared.keyWindow?.rootViewController?.present(alert,animated: true,completion: nil)
            //fetch()
      //      loadnoticefromcoredata()
            
            
        }
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
