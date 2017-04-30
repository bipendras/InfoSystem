
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
import AlamofireImage
var gid = 0
var albumtitle = "Album Images"
class galleryTableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var navitem: UINavigationItem!
    @IBOutlet var menuButton:UIBarButtonItem!
    @IBOutlet var reloadbtn:UIBarButtonItem!
    
    //let galleryurl:String = "http://demo.nbulletin.com/api/v1/gallery?api_token=a1"
    //let galleryurl:String = "http://demo.nbulletin.com/api/v1/gallery?api_token=a1"//"http://nbulletin.com/api/client/gallery?api_token=a1"
    @IBOutlet weak var tableView: UITableView!
    var TableData:Array < datastruct > = Array < datastruct >()
    var edict = ["id": 0, "title": "","cover_image" : "","created_at" : "","Updated_at" : ""] as [String : Any]
    //let dict = edict as! NSDictionary
    var TData: datastruct = datastruct(add:["id":0])
    struct datastruct
    {
        var id:Int16?
        var title:String?
        var cover_image:String?
        //   var tag:String?
        var created_at:String?
        var updated_at:String?
        //var attmsg:NSAttributedString
        init(add: NSDictionary)
        {
            id = add["id"] as? Int16
            title    = add["title"] as? String
            cover_image = add["cover_image"] as? String
            //     tag   = add["tag"] as? String
            created_at = add["created_at"] as? String
            updated_at   = add["updated_at"] as? String
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            let btn1 = UIButton(type: .custom)
            btn1.setImage(UIImage(named: "menubtnimg"), for: .normal)
            btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn1.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            let item1 = UIBarButtonItem(customView: btn1)
            
            let btn2 = UIButton(type: .custom)
            btn2.setImage(UIImage(named: "reloadbtnimg"), for: .normal)
            btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn2.addTarget(revealViewController(), action: #selector(reload(_:)), for: .touchUpInside)
            let item2 = UIBarButtonItem(customView: btn2)
            
            self.navigationItem.setRightBarButtonItems([item2], animated: true)
            self.navigationItem.setLeftBarButtonItems([item1], animated: true)
            //navitem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menubtnimg"), style: <#T##UIBarButtonItemStyle#>, target: revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
          //  navitem.leftBarButtonItem?.target = revealViewController()
          //  navitem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:))
          //  navitem.leftBarButtonItem?.setBackgroundImage(UIImage(named: "menubtnimg"), for: .normal, barMetrics: <#T##UIBarMetrics#>) //= UIImage(named: "menubtnimg")
            //revealViewController().rightViewRevealWidth = 150
            //extraButton.target = revealViewController()
            //extraButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            
            
            
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 240
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //fetch()
        
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            // clearCoreData("Noticeentity")
            // notish.removeAll()
            loadgalleryfromcoredata()
            
            clearCoreData(entity: "Gallery")
            
            loadgalleryfromurl()
            
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
            loadgalleryfromcoredata()
            
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
        let newdata = NSEntityDescription.insertNewObject(forEntityName: "Gallery", into: context) as NSManagedObject
        
        print(dataset)
        //set the entity values
        newdata.setValue(dataset.id, forKey: "id")
        newdata.setValue(dataset.title , forKey: "title")
        newdata.setValue(dataset.created_at , forKey: "created_at")
        newdata.setValue(dataset.updated_at, forKey: "updated_at")
        newdata.setValue(dataset.cover_image, forKey: "cover_image")
        
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
     func reload(_ sender: Any) {
        
        clearCoreData(entity: "Gallery")
        get_data_from_url(url: galleryurl)
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
    
    func loadgalleryfromurl(){
        get_data_from_url(url: galleryurl)
        
    }
    func loadgalleryfromcoredata(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        let appDel:AppDelegate = (UIApplication.shared.delegate) as! AppDelegate
        
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Gallery", in: context)
        fetchRequest.includesPropertyValues = false
        do {
            if let results = try context.fetch(fetchRequest) as? [NSManagedObject] {
                
                print(results.count)
                TableData.removeAll()
                for result in results {
                    edict["id"] = result.value(forKey: "id") as? Int16
                    edict["cover_image"] = result.value(forKey: "cover_image") as? String
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
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return TableData.count
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedRow = TableData[indexPath.row]
        gid = Int(selectedRow.id!)
        albumtitle = selectedRow.title!
        //UIApplication.shared.openURL(NSURL(string: selectedRow.url!)! as URL)
        //  let destinationVC = NoticeDetailViewController()
        // destinationVC.IData = selectedRow
        
        //destinationVC.performSegueWithIdentifier("NoticeDetailSegue", sender:self)
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! galleryTableViewCell
        
        let data = TableData[indexPath.row]
        print(data)
        
        cell.cellTitle.text = data.title! as String//data.valueForKey("title") as? String
        cell.cellUpdated.text = data.updated_at! as String
        cell.cellImage.af_setImage(withURL: URL(string: data.cover_image! as String)!)
        //cell.celldate.text = data.id! as String
        
        //data.message! as String//data.valueForKey("message") as? String//data.message
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
            print(list)
            let gallery: NSArray = list["gallery"]! as! NSArray
            // let coverimage:NSArray = list["coverimage"] as! NSArray
            //print(coverimage)
            
            for galleries in gallery{//
                let glris = galleries as! NSDictionary
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
                store(dataset: datastruct(add: glris))
                
                //   TableData.append(datastruct(add: sty))
                // print(TableData)
            }
            
            loadgalleryfromcoredata()
            
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
        print("galleryclear")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
    }
    
    
    
    
}




