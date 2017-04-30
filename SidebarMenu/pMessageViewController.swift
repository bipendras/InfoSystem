//
//  pMessageViewController.swift
//  nBulletin
//
//  Created by beependra on 2/20/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import AlamofireImage

class pMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    //
    //  ViewController.swift
    //  fscalenderr
    //
    //  Created by beependra on 12/14/16.
    //  Copyright © 2016 beependra. All rights reserved.
    //
    //
    //
    
         var TableData:Array < datastruct > = Array < datastruct >()
        var edict = ["from": "", "name": "","image" : "","message" : "","created_at" : ""] as [String : Any]
        var TData: datastruct = datastruct(add:["from":""])
        let apitoken = datadef.object(forKey: "studentToken") as? String
        
        // let json_dataa:String = "demo.nbulletin.com/api/v1/event?api_token=a1"//"http://nbulletin.com/api/client/event?api_token=a1"//3"
    
        enum ErrorHandler:Error
        {
            case ErrorFetchingResults
        }
        struct datastruct
        {
            var from:String?
            var name:String?
            var image:String?
            var message:String?
            var created_at:String?
            //   var count:String?
            init(add: NSDictionary)
            {
                from  = add["from"] as? String
                name  = add["name"] as? String
                image   = add["image"] as? String
                message = add["message"] as? String
                created_at = add["created_at"] as? String
                //  count = add["count"] as? String
                
                //    imageurl = add["image"] as? String
                //print(message)
                //  description = add["description"] as? String
            }
        }
        
        
        @IBAction func reloadaction(sender: AnyObject) {
            TableData.removeAll()
            get_data_from_url(url: pmessageurl)
            
            
            do_table_refresh()
        }
    
        
        override func viewDidLoad() {
            
            super.viewDidLoad()
            if revealViewController() != nil {
                //            revealViewController().rearViewRevealWidth = 62
                
                //revealViewController().rightViewRevealWidth = 150
                //extraButton.target = revealViewController()
                //extraButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
                
                view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                
                tableView.rowHeight = UITableViewAutomaticDimension
                tableView.estimatedRowHeight = 140
                
                
            }
            tableView.dataSource = self
            tableView.delegate = self
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 240
            tableViewScrollToBottom(animated: false)
            // get_data_from_url(url: eventurl)
            
            // tableView.rowHeight = UITableViewAutomaticDimension
            // tableView.estimatedRowHeight = 140
            
            //
            // Do any additional setup after loading the view, typically from a nib.
        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            //fetch()
            if Reachability.isConnectedToNetwork() == true {
                print("Internet connection OK")
                // clearCoreData("Noticeentity")
                // notish.removeAll()
                // loadeventfromcoredata()
                loadpmessagefromcoredata()
                
                clearCoreData(entity: "Pmessage")
                
                loadpmessagefromurl()
                
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
                loadpmessagefromcoredata()
                
                self.tableView.reloadData()
              //  self.scrollBottom()
            }
           
        }
        
        
        func get_data_from_url(url:String)
        {
            
            
            let url:NSURL = NSURL(string: url)!
            let session = URLSession.shared
            
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            
            
            let task = session.dataTask(with: request as URLRequest) {
                (
                data, response, error) in
                
                guard let _:NSData = data as NSData?, let _:URLResponse = response  , error == nil else {
                    print("error")
                    
                    return
                }
                //print(data)
                
                DispatchQueue.main.async(execute: {
                    self.extract_json(jsonData: data! as NSData)
                    return
                })
                
            }
            tableView.reloadData()
            task.resume()
            //loadnoticefromcoredata()
            
            
        }
        func extract_json(jsonData:NSData)
        {
            //   print("extract_json function")
            let json: AnyObject?
            do {
                //  print("uoto let json")
                
                json = try JSONSerialization.jsonObject(with: jsonData as Data, options: []) as AnyObject?
                //print(json)
            } catch {
                json = nil
                print("nil")
                return
            }
            //    if let json = json as? NSDictionary {
            //      print("dictionary recieved");
            //  }
            
            
            if    let list = json as? NSDictionary// NSArray
                //if let json:AnyObject = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil)
            {
                
                let pmessage: NSArray = list["message"]! as! NSArray
                // let coverimage:NSArray = list["coverimage"] as! NSArray
                //print(coverimage)
                
                for messages in pmessage{//
                    let msg = messages as! NSDictionary
                    // let cid = not["message"]
                    ///chapter = ttl["chapter"] as? String
                    /// body = ttl["body"] as? String
                    ///  image = ttl["image"] as? String
                    ///  chapterlabel.text = chapter
                    ///  bodylabel.text = body
                    ///loadImageFromUrl(url: image!, view: imagee)
                    // print(sty.value(forKey: "id"))
                    //print(nts)
                    //print(datastruct(add:nts))
                    store(dataset: datastruct(add: msg))
                    
                    //   TableData.append(datastruct(add: sty))
                    // print(TableData)
                }
                
                loadpmessagefromcoredata()
                
            }
            
            
        }
        func store (dataset: datastruct) {
            
            
            
            //retrieve the entity that we just created
            let appDel:AppDelegate = (UIApplication.shared.delegate) as! AppDelegate
            
            let context:NSManagedObjectContext = appDel.managedObjectContext
            
            
            //2
            let newdata = NSEntityDescription.insertNewObject(forEntityName: "Pmessage", into: context) as NSManagedObject
            
            // print(dataset)
            //set the entity values
            newdata.setValue(dataset.from, forKey: "from")
            newdata.setValue(dataset.created_at , forKey: "created_at")
            newdata.setValue(dataset.message, forKey: "message")
            newdata.setValue(dataset.name, forKey: "name")
            newdata.setValue(dataset.image, forKey: "image")
            //transc.setValue(textFileUrlString, forKey: "textFileUrlString")
            //contentview.layer.cornerRadius = 10
            //save the object
            do {
                try context.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                
            }
        }
        @IBAction func reload(_ sender: Any) {
            
            clearCoreData(entity: "Event")
            get_data_from_url(url: eventurl)
            print(TableData.count)
            do_table_refresh()
            
        }
        func do_table_refresh()
        {
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
                return
            })
        }
        
        func loadpmessagefromurl(){
            get_data_from_url(url: "\(pmessageurl)\(apitoken!)")
            
        }
        func loadpmessagefromcoredata(){
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
            
            let appDel:AppDelegate = (UIApplication.shared.delegate) as! AppDelegate
    
            let context:NSManagedObjectContext = appDel.managedObjectContext
            
            fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Pmessage", in: context)
            fetchRequest.includesPropertyValues = false
            do {
                if let results = try context.fetch(fetchRequest) as? [NSManagedObject] {
                    
                    print(results.count)
                    TableData.removeAll()
                    for result in results {
                        edict["name"] = result.value(forKey: "name") as? String
                        edict["from"] = result.value(forKey: "from") as? String
                        edict["created_at"] = result.value(forKey: "created_at") as? String
                        edict["message"] = result.value(forKey: "message") as? String
                        edict["image"] = result.value(forKey: "image") as? String
                        
                        
                        
                        TableData.append(datastruct(add: edict as NSDictionary))
                        
                        //TData[results.count] =
                        //context.delete(result)
                        // print(context.value(forKey: "id"))
                    }
                    // print(TableData)
                    //try context.save()
                    //  tableView.reloadData()
                    
                }
            } catch {
                // LOG.debug("failed to clear core data")
            }
            //print("dataclear")
            
            
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
    func tableViewScrollToBottom(animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! messageTableViewCell
            
            
            let data = TableData[indexPath.row]
            //print(data)
            
           // cell.cellTitle?.text = data.name
            cell.cellTitle?.text = data.message// cellSubtitle?.text = data.message
            cell.cellSubtitle?.text = data.name
            cell.cellDate?.text = data.created_at
            
            cell.cellImage?.af_setImage(withURL: URL(string: data.image!)!)
           // cell.celldate.textColor = primaryColor
           // cell.cellDatee.textColor = primaryColor
           // cell.c?.af_setImage(withURL: URL(string: data.image!)
          /*
            var datearr = data.start_date?.components(separatedBy: " ")
            let index = datearr?[0].index((datearr?[0].startIndex)!, offsetBy: 7)
            cell.cellDatee.text = datearr?[0].substring(to: index!)
            cell.celldate.text = ("\((datearr?[0][8])!)\((datearr?[0][9])!)")
            */
            //   calendar(calendar, hasEventFor: formatter.date(from: data.start_date!)!)
            // cell.celldate?.text = datedata.
            //cell.cellDatee?.text =
            //print(data.start_date)
            //print(data)
            
            //print(data.start_date!)
            //   print(   self.formater.date(from: data.start_date!))
            
            // print("hello")
            //print(data.title
            //cell.textLabel?.text = data.title
            // cell.detailTextLabel?.text = data.message
            // print(data.title)
            
            return cell
            
        }
        
        func clearCoreData(entity:String) {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
            
            let appDel:AppDelegate = (UIApplication.shared.delegate) as! AppDelegate
            
            let context:NSManagedObjectContext = appDel.managedObjectContext
            
            fetchRequest.entity = NSEntityDescription.entity(forEntityName: entity, in: context)
            fetchRequest.includesPropertyValues = false
            do {
                if let results = try context.fetch(fetchRequest) as? [NSManagedObject] {
                    for result in results {
                        context.delete(result)
                    }
                    
                    try context.save()
                }
            } catch {
                // LOG.debug("failed to clear core data")
            }
            print("pmessageclear")
        }
        
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            print("tablecount")
            
            //print(TableData.count)
            
            return TableData.count
       //     self.scrollBottom()
            
            
        }
    func scrollBottom(){
        DispatchQueue.global(qos: .background).async {
            if self.TableData.count != 0 {
            let indexPth = IndexPath(row: self.TableData.count - 1, section: 0)
            //print(indexPth)
            self.tableView.scrollToRow(at: indexPth, at: .bottom, animated: true)
            }
        }
    }
    
        //TableData[indexPath.row].start_date
        
        /* func do_table_refresh()
         {
         DispatchQueue.main.async(execute: {
         self.tableView.reloadData()
         return
         })
         }
         */
        
        
        
        
        
        
        
        
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
