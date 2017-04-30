//
//  newsViewController.swift
//  SidebarMenu
//
//  Created by beependra on 1/5/17.
//  

import UIKit
import SystemConfiguration
import CoreData


class contactTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet var menuButton:UIBarButtonItem!
    @IBOutlet var reloadbtn:UIBarButtonItem!
    
    //let contacturl:String = "http://demo.nbulletin.com/api/v1/contact?api_token=a1"
    
    @IBOutlet weak var tableView: UITableView!
    var TableData:Array < datastruct > = Array < datastruct >()
    var edict = ["id": 0, "name": "","email" : "","designation" : "","Updated_at" : "", "created_at" : "", "image_thumb" : "", "contact" : ""] as [String : Any]
    //let dict = edict as! NSDictionary
    var TData: datastruct = datastruct(add:["id":0])
    struct datastruct
    {
        var id:Int16?
        var name:String?
        var email:String?
        //   var tag:String?
        var created_at:String?
        var updated_at:String?
        var designation:String?
        var contact:String?
        var image_thumb:String?
        //var attmsg:NSAttributedString
        init(add: NSDictionary)
        {
            id = add["id"] as? Int16
            name    = add["name"] as? String
            email = add["email"] as? String
            //     tag   = add["tag"] as? String
            created_at = add["created_at"] as? String
            updated_at   = add["updated_at"] as? String
            designation = add["designation"] as? String
            contact = add["contact"] as? String
            image_thumb = add["image_thumb"] as? String
            
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
            loadcontactfromcoredata()
            
            clearCoreData(entity: "Contact")
            
            loadcontactfromurl()
            
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
            loadcontactfromcoredata()
            
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
        let newdata = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: context) as NSManagedObject
        
        print(dataset)
        //set the entity values
        newdata.setValue(dataset.id, forKey: "id")
        newdata.setValue(dataset.name , forKey: "name")
        newdata.setValue(dataset.created_at , forKey: "created_at")
        newdata.setValue(dataset.updated_at, forKey: "updated_at")
        newdata.setValue(dataset.image_thumb, forKey: "image_thumb")
        newdata.setValue(dataset.email, forKey: "email")
        newdata.setValue(dataset.designation, forKey: "designation")
        newdata.setValue(dataset.contact, forKey: "contact")
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
    
        clearCoreData(entity: "Contact")
        get_data_from_url(url: contacturl)
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
    
    func loadcontactfromurl(){
        get_data_from_url(url: contacturl)
        
    }
    func loadcontactfromcoredata(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        let appDel:AppDelegate = (UIApplication.shared.delegate) as! AppDelegate
        
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Contact", in: context)
        fetchRequest.includesPropertyValues = false
        do {
            if let results = try context.fetch(fetchRequest) as? [NSManagedObject] {
                
                print(results.count)
                TableData.removeAll()
                for result in results {
                    edict["id"] = result.value(forKey: "id") as? Int16
                    edict["name"] = result.value(forKey: "name") as? String
                    edict["email"] = result.value(forKey: "email") as? String
                    edict["created_at"] = result.value(forKey: "created_at") as? String
                    edict["updated_at"] = result.value(forKey: "updated_at") as? String
                    edict["designation"] = result.value(forKey: "designation") as? String
                    edict["contact"] = result.value(forKey: "contact") as? String
                    edict["image_thumb"] = result.value(forKey: "image_thumb") as? String
                    
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
        let alerta = UIAlertController(title: selectedRow.name!, message: "Call or Email?", preferredStyle: .actionSheet)
        alerta.addAction(UIAlertAction(title: "Call", style: .default){ action in
            print("callaction")
            //print(selectedRow.contact)
            //let formattednumber = selectedRow.contact?.components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
            //print(formattednumber)
            //let phoneurl = "tel://\(selectedRow.contact!)"
           // let url:NSURL = NSURL(string: phoneurl)!
           // UIApplication.shared.openURL(url as URL)
            
            if let url = URL(string: "tel://\(selectedRow.contact!)"), UIApplication.shared.canOpenURL(url){
                UIApplication.shared.openURL(url)
            }
            else{
                print("callnotpossible")
            }
           // UIApplication.shared.openURL(NSURL(scheme: NSString() as String, host: "tel://", path: selectedRow.contact!)! as URL)
            
        })
        alerta.addAction(UIAlertAction(title: "Email", style: .default){ action in
            print("emailaction")
            // let toemail = selectedRow.email
            if let urlstring = URL(string: "mailto:\(selectedRow.email!)"), UIApplication.shared.canOpenURL(urlstring){
                UIApplication.shared.openURL(urlstring)
            }//, UIApplication.shared.canOpenURL(urlstring){
            // UIApplication.shared.openURL(urlstring!)
            // }
            
           // alerta.view.tintColor = UIColor.red
        })
        alerta.addAction(UIAlertAction(title: "Cancel", style: .cancel){ action in
            print("cancel")
            alerta.dismiss(animated: true, completion: {
                
            })
            // let toemail = selectedRow.email
            //if let urlstring = URL(string: "mailto:\(selectedRow.email!)"), UIApplication.shared.canOpenURL(urlstring){
            //    UIApplication.shared.openURL(urlstring)
            //, UIApplication.shared.canOpenURL(urlstring){
            // UIApplication.shared.openURL(urlstring!)
            // }
            
        })
        self.present(alerta, animated: true)
        //  let destinationVC = NoticeDetailViewController()
        // destinationVC.IData = selectedRow
        
        //destinationVC.performSegueWithIdentifier("NoticeDetailSegue", sender:self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! contactsTableViewCell
        
        let data = TableData[indexPath.row]
       
        cell.cellName.text = data.name! as String//data.valueForKey("title") as? String
        cell.cellNo.text = data.contact! as String
        cell.cellEmail.text = (data.email)! as String
        cell.cellDesignation.text = data.designation! as String
        cell.cellImage.af_setImage(withURL: URL(string: data.image_thumb!)!)
        cell.cellImage.layer.cornerRadius = 10
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
            
            let contact: NSArray = list["contact"]! as! NSArray
            // let coverimage:NSArray = list["coverimage"] as! NSArray
            //print(coverimage)
            
            for contacts in contact{//
                let cntact = contacts as! NSDictionary
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
                store(dataset: datastruct(add: cntact))
                
                //   TableData.append(datastruct(add: sty))
                // print(TableData)
            }
            
            loadcontactfromcoredata()
            
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
        print("contactclear")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
    }
    
    
    
    
}

