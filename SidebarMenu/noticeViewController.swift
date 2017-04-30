//
//  noticeViewController.swift
//  SidebarMenu
//
//  Created by beependra on 1/5/17.
//  Copyright © 2017 Leading Professional Technology. All rights reserved.
//

import UIKit
import SystemConfiguration
import CoreData

var notish = [NSManagedObject]()
class noticeViewController: UITableViewController {
    @IBOutlet var menuButton:UIBarButtonItem!
    @IBOutlet var extraButton:UIBarButtonItem!
    @IBOutlet weak var slider: UIScrollView!
    
    var dateey:NSDate?
    var datees:String?
    
    //let noticeurl:String = "http://demo.nbulletin.com/api/v1/notice?api_token=a1"
    var dateformatter = DateFormatter()
    let dayformatter = DateFormatter()
   
    // dateformatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
    var TableData:Array < datastruct > = Array < datastruct >()
    var edict = ["id": 0, "title": "","message" : "","created_at" : "","Updated_at" : ""] as [String : Any]
    //let dict = edict as! NSDictionary
    var TData: datastruct = datastruct(add:["id":0])
    struct datastruct
    {
        var id:Int16?
        var title:String?
        var message:String?
        //   var tag:String?
        var created_at:String?
        var updated_at:String?
        //var attmsg:NSAttributedString
        init(add: NSDictionary)
        {
            id = add["id"] as? Int16
            title    = add["title"] as? String
            message = add["message"] as? String
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
            
            revealViewController().rightViewRevealWidth = 150
            extraButton.target = revealViewController()
            extraButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
            
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 240
        
    }
    
    @IBAction func reload(_ sender: Any) {
        
        clearCoreData(entity: "Notice")
        get_data_from_url(url: noticeurl)
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //fetch()
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            // clearCoreData("Noticeentity")
            // notish.removeAll()
            self.edgesForExtendedLayout = []
            loadnoticefromcoredata()
            slider.auk.settings.placeholderImage = UIImage(named: "aiabg")
            slider.auk.settings.preloadRemoteImagesAround = 1
            slider.auk.startAutoScroll(delaySeconds: 2)
            Moa.settings.cache.requestCachePolicy = .returnCacheDataElseLoad
            clearCoreData(entity: "Notice")
            //loadnoticefromcoredata()
            
            loadnoticefromurl()
            
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
            loadnoticefromcoredata()
            
            
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
        
        task.resume()
        //loadnoticefromcoredata()
        
        
    }
    
    func store (dataset: datastruct) {
        
       
        
        //retrieve the entity that we just created
        let appDel:AppDelegate = (UIApplication.shared.delegate) as! AppDelegate
        
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        
        //2
        let newdata = NSEntityDescription.insertNewObject(forEntityName: "Notice", into: context) as NSManagedObject
       
      //  print(dataset)
        //set the entity values
        newdata.setValue(dataset.id, forKey: "id")
        newdata.setValue(dataset.title , forKey: "title")
        newdata.setValue(dataset.created_at , forKey: "created_at")
        newdata.setValue(dataset.updated_at, forKey: "updated_at")
        newdata.setValue(dataset.message, forKey: "message")
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
    
    
    func loadnoticefromurl(){
        get_data_from_url(url: noticeurl)
        
    }
    func loadnoticefromcoredata(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        let appDel:AppDelegate = (UIApplication.shared.delegate) as! AppDelegate
        
        let context:NSManagedObjectContext = appDel.managedObjectContext
    
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Notice", in: context)
        fetchRequest.includesPropertyValues = false
        do {
            if let results = try context.fetch(fetchRequest) as? [NSManagedObject] {
                
                print(results.count)
                TableData.removeAll()
                for result in results {
                    edict["id"] = result.value(forKey: "id") as? Int16
                    edict["message"] = result.value(forKey: "message") as? String
                    edict["title"] = result.value(forKey: "title") as? String
                    edict["created_at"] = result.value(forKey: "created_at") as? String
                    edict["updated_at"] = result.value(forKey: "updated_at") as? String
                    
                    TableData.append(datastruct(add: edict as NSDictionary))
                    print(TableData.count)
                    //TData[results.count] =
                    //context.delete(result)
                   // print(context.value(forKey: "id"))
                }
                print(TableData.count)
                //try context.save()
                
                
            }
        } catch {
            // LOG.debug("failed to clear core data")
        }
        //print("dataclear")

        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
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
        print(TableData.count)
        return TableData.count
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        // 1. set the initial state of the cell
        cell.alpha = 0
        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
        cell.layer.transform = transform
        
        // 2. UIView animation method to change to the final state of the cell
        UIView.animate(withDuration: 1.0, animations: {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        })
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! noticeTableViewCell
        
        let data = TableData[indexPath.row]
    
        
        cell.cellTitle.text = data.title! as String//data.valueForKey("title") as? String
        cell.celldate.textColor = primaryColor
        cell.cellDatee.textColor = primaryColor
        //dateformatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        cell.cellDatee.text = data.updated_at! as String
       // print(data.updated_at!)
        
        
        dateformatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dayformatter.dateFormat = "dd"
        
        dateey = dateformatter.date(from: data.created_at!) as NSDate?
        //datees = dateformatter.string(from: dateey! as Date)
        
        
        var datearr = data.updated_at?.components(separatedBy: " ")
        let index = datearr?[0].index((datearr?[0].startIndex)!, offsetBy: 7)
        cell.cellDatee.text = datearr?[0].substring(to: index!)
        cell.celldate.text = ("\((datearr?[0][8])!)\((datearr?[0][9])!)")
            
        //    print("\((datearr?[0][8])!)\((datearr?[0][9])!)")
        
        // print(data.updated_at!)
        //dateey = data.updated_at?.toDateTime(format: "yyyy-MM-dd hh:mm:ss") as NSDate?//.string(format: "dd")
     //   print(datees)    // var dateyy = data.updated_at?.toDateTime(format: "yyyy-MM-dd hh:mm:ss").string(format: "MMM,yyyy")
       // var dtt = NSDate()
       //  dtt = dateformatter.date(from: data.updated_at!) as NSDate
       // var dtt1 = dateformatter.string(from: dtt as Date)
    //    print("what \(String(describing: dtt))")
       // cell.cellDatee.text = dtt1
      //  cell.celldate.text = dateformatter.string(from: dtt!)
      //cell.cellDatee.text = dateyy//data.updated_at?.toDateTime(format: "yyyy-MM-dd hh:mm:ss").string(format: "MMM,yyyy")// //Usage var myDate = myDateString.toDateTime()
                                //usage Date().string(format: "yyyy-MM-dd")

        cell.cellSubtitle.text = data.message!.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)//data.message! as String//data.valueForKey("message") as? String//data.message
        return cell
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
            
            let notice: NSArray = list["notice"]! as! NSArray
            // let coverimage:NSArray = list["coverimage"] as! NSArray
            //print(coverimage)
            
            for notices in notice{//
                let nts = notices as! NSDictionary
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
                store(dataset: datastruct(add: nts))
            //    print(nts)
                //   TableData.append(datastruct(add: sty))
                // print(TableData)
            }
            slider.auk.removeAll()
            
            let slidr: NSArray = list["slider"] as! NSArray
            for sliders in slidr{
                let sldrs = sliders as! NSDictionary
                if let imgg = sldrs["image_thumb"] as? String {
                    slider.auk.show(url: imgg)
                    
                }
                else{
                    
                }
                
                
            }
            //loadnoticefromcoredata()
            
        }
        
        
    }
    func clearCoreData(entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        let appDel:AppDelegate = (UIApplication.shared.delegate) as! AppDelegate
        
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Notice", in: context)
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
        print("dataclear")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    //func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "noticeDetailSegue"){
            let SelectedIndexPath:NSIndexPath = self.tableView.indexPathForSelectedRow! as NSIndexPath
            let noticeDetailViewController:NoticeDetailViewController = segue.destination as! NoticeDetailViewController
            print(TableData[SelectedIndexPath.row])
            noticeDetailViewController.NoticeData = TableData[SelectedIndexPath.row]
            //noticeDetailViewController.titlee = notish[SelectedIndexPath.row].value(forKey: "title") as? String
           // noticeDetailViewController.messagee = notish[SelectedIndexPath.row].value(forKey: "message") as? NSAttributedString
            
        }
    }

}
