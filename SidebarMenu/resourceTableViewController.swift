//
//  resourceTableViewController.swift
//  nBulletin
//
//  Created by beependra on 2/14/17.
//  Copyright © 2017 Leading Professional Technology. All rights reserved.
//


import UIKit
import SystemConfiguration
import CoreData


class resourceTableViewController: UITableViewController {
    
    
    @IBOutlet var menuButton:UIBarButtonItem!
    @IBOutlet var reloadbtn:UIBarButtonItem!
    
   // let resourceurl:String = "http://demo.nbulletin.com/api/v1/resource?api_token=a1"
    
    var TableData:Array < datastruct > = Array < datastruct >()
    var edict = ["id": 0, "title": "","url" : "","created_at" : "","Updated_at" : ""] as [String : Any]
    //let dict = edict as! NSDictionary
    var TData: datastruct = datastruct(add:["id":0])
    struct datastruct
    {
        var id:Int16?
        var title:String?
        var url:String?
        //   var tag:String?
        var created_at:String?
        var updated_at:String?
        //var attmsg:NSAttributedString
        init(add: NSDictionary)
        {
            id = add["id"] as? Int16
            title    = add["title"] as? String
            url = add["url"] as? String
            //     tag   = add["tag"] as? String
            created_at = add["created_at"] as? String
            updated_at   = add["updated_at"] as? String
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            //revealViewController().rightViewRevealWidth = 150
            //extraButton.target = revealViewController()
            //extraButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 240
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //fetch()
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            // clearCoreData("Noticeentity")
            // notish.removeAll()
            loadresourcefromcoredata()  
            
            clearCoreData(entity: "Resource")
            
            loadresourcefromurl()
            
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
            loadresourcefromcoredata()
            
            self.tableView.reloadData()
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
    
    func store (dataset: datastruct) {
        
        
        
        //retrieve the entity that we just created
        let appDel:AppDelegate = (UIApplication.shared.delegate) as! AppDelegate
        
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        
        //2
        let newdata = NSEntityDescription.insertNewObject(forEntityName: "Resource", into: context) as NSManagedObject
        
        print(dataset)
        //set the entity values
        newdata.setValue(dataset.id, forKey: "id")
        newdata.setValue(dataset.title , forKey: "title")
        newdata.setValue(dataset.created_at , forKey: "created_at")
        newdata.setValue(dataset.updated_at, forKey: "updated_at")
        newdata.setValue(dataset.url, forKey: "url")
        
        //transc.setValue(textFileUrlString, forKey: "textFileUrlString")
        
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
        
        clearCoreData(entity: "Resource")
        get_data_from_url(url: resourceurl)
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
    func loadresourcefromurl(){
        get_data_from_url(url: resourceurl)
        
    }
    func loadresourcefromcoredata(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        let appDel:AppDelegate = (UIApplication.shared.delegate) as! AppDelegate
        
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Resource", in: context)
        fetchRequest.includesPropertyValues = false
        do {
            if let results = try context.fetch(fetchRequest) as? [NSManagedObject] {
                
                print(results.count)
                TableData.removeAll()
                for result in results {
                    edict["id"] = result.value(forKey: "id") as? Int16
                    edict["url"] = result.value(forKey: "url") as? String
                    edict["title"] = result.value(forKey: "title") as? String
                    edict["created_at"] = result.value(forKey: "created_at") as? String
                    edict["updated_at"] = result.value(forKey: "updated_at") as? String
                    
                    TableData.append(datastruct(add: edict as NSDictionary))
                    
                    //TData[results.count] =
                    //context.delete(result)
                    // print(context.value(forKey: "id"))
                }
                // print(TableData)
                //try context.save()
                tableView.reloadData()
                
            }
        } catch {
            // LOG.debug("failed to clear core data")
        }
        //print("dataclear")
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return TableData.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedRow = TableData[indexPath.row]
        UIApplication.shared.openURL(NSURL(string: selectedRow.url!)! as URL)
        //  let destinationVC = NoticeDetailViewController()
        // destinationVC.IData = selectedRow
        
        //destinationVC.performSegueWithIdentifier("NoticeDetailSegue", sender:self)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! resourceTableViewCell
        
        let data = TableData[indexPath.row]
        print(data)
        cell.cellTitle.text = data.title! as String//data.valueForKey("title") as? String
        cell.celldate.textColor = primaryColor
        cell.cellDatee.textColor = primaryColor
        
        var datearr = data.updated_at?.components(separatedBy: " ")
        let index = datearr?[0].index((datearr?[0].startIndex)!, offsetBy: 7)
        cell.cellDatee.text = datearr?[0].substring(to: index!)
        cell.celldate.text = ("\((datearr?[0][8])!)\((datearr?[0][9])!)")
        
        
        //cell.celldate.text = data.id! as String
        
        //data.message! as String//data.valueForKey("message") as? String//data.message
        return cell
    }
    func loadImageFromUrl(url: String, view: UIImageView){
        
        // Create Url from string
        let url = NSURL(string: url)!
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = URLSession.shared.dataTask(with: url as URL) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                DispatchQueue.main.async(execute: { () -> Void in
                    view.image = UIImage(data: data)
                    //    img = UIImage(<#T##NSData#>data: )
                })
            }
        }
        
        // Run task
        task.resume()
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
            
            let resource: NSArray = list["resource"]! as! NSArray
            // let coverimage:NSArray = list["coverimage"] as! NSArray
            //print(coverimage)
            
            for resources in resource{//
                let rsrs = resources as! NSDictionary
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
                store(dataset: datastruct(add: rsrs))
                
                //   TableData.append(datastruct(add: sty))
                // print(TableData)
            }
            
            loadresourcefromcoredata()
            
        }
        
        
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
        print("resourceclear")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
    }
    
    
    
    
}

