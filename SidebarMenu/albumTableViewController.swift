//
//  ViewController.swift
//  gallerytest
//
//  Created by beependra on 12/25/16.
//  Copyright © 2016 beependra. All rights reserved.
//



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
class albumTableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var menuButton:UIBarButtonItem!
    @IBOutlet var reloadbtn:UIBarButtonItem!
    var alurl:String = " "
    //let galleryurl:String = "http://demo.nbulletin.com/api/v1/gallery?api_token=a1"
    //var albumurl:String = "http://demo.nbulletin.com/api/v1/gallery/"//8?api_token=a1"//"http://nbulletin.com/api/client/gallery/3?api_token=a1"
    @IBOutlet weak var tableView: UITableView!
    var TableData:Array < datastruct > = Array < datastruct >()
    var edict = ["id": 0, "image": "","image_thumb" : "","created_at" : "","Updated_at" : ""] as [String : Any]
    //let dict = edict as! NSDictionary
    var TData: datastruct = datastruct(add:["id":0])
    struct datastruct
    {
        var id:Int16?
        var image:String?
        var image_thumb:String?
        //   var tag:String?
        var created_at:String?
        var updated_at:String?
        //var attmsg:NSAttributedString
        init(add: NSDictionary)
        {
            id = add["id"] as? Int16
            image    = add["image"] as? String
            image_thumb = add["image_thumb"] as? String
            //     tag   = add["tag"] as? String
            created_at = add["created_at"] as? String
            updated_at   = add["updated_at"] as? String
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            //  menuButton.target = revealViewController()
            // menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            
            //revealViewController().rightViewRevealWidth = 150
            //extraButton.target = revealViewController()
            //extraButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            
            //view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 240
            
        }
        self.title = albumtitle
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //fetch()
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            alurl = ("\(albumurl)\(gid)")
            //print(albumurl)
            alurl = alurl + "?api_key=\(api_key)"
      //      print(alurl)
            // clearCoreData("Noticeentity")
            // notish.removeAll()
            loadalbumfromcoredata()
            
            clearCoreData(entity: "Album")
            
            loadalbumfromurl()
            
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
            loadalbumfromcoredata()
            
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
        let newdata = NSEntityDescription.insertNewObject(forEntityName: "Album", into: context) as NSManagedObject
        
        print(dataset)
        //set the entity values
        newdata.setValue(dataset.id, forKey: "id")
        newdata.setValue(dataset.image , forKey: "image")
        newdata.setValue(dataset.created_at , forKey: "created_at")
        newdata.setValue(dataset.updated_at, forKey: "updated_at")
        newdata.setValue(dataset.image_thumb, forKey: "image_thumb")
        
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
        
        clearCoreData(entity: "Album")
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
    
    func loadalbumfromurl(){
        get_data_from_url(url: alurl)
        
    }
    func loadalbumfromcoredata(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        let appDel:AppDelegate = (UIApplication.shared.delegate) as! AppDelegate
        
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Album", in: context)
        fetchRequest.includesPropertyValues = false
        do {
            if let results = try context.fetch(fetchRequest) as? [NSManagedObject] {
                
                print(results.count)
                TableData.removeAll()
                for result in results {
                    edict["id"] = result.value(forKey: "id") as? Int16
                    edict["image"] = result.value(forKey: "image") as? String
                    edict["image_thumb"] = result.value(forKey: "image_thumb") as? String
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
        
        //UIApplication.shared.openURL(NSURL(string: selectedRow.url!)! as URL)
        //  let destinationVC = NoticeDetailViewController()
        // destinationVC.IData = selectedRow
        
        //destinationVC.performSegueWithIdentifier("NoticeDetailSegue", sender:self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! albumTableViewCell
        
        let data = TableData[indexPath.row]
        //print(data)
        //cell.cellTitle.text = data.title! as String//data.valueForKey("title") as? String
        cell.cellUpdated.text = data.updated_at! as String
        cell.cellImage.af_setImage(withURL: URL(string: data.image_thumb! as String)!)
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
            let album: NSArray = list["gallery"]! as! NSArray
            // let coverimage:NSArray = list["coverimage"] as! NSArray
            //print(coverimage)
            
            for galleries in album{//
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
            
            loadalbumfromcoredata()
            
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
        print("albumclear")
    }
    
   
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "imageDetailSegue"){
            let SelectedIndexPath:NSIndexPath = self.tableView.indexPathForSelectedRow! as NSIndexPath
            let imgdetailviewcontroller:detimgViewController = segue.destination as! detimgViewController
            //noticeDetailViewController.IData = notis[SelectedIndexPath.row]
            imgdetailviewcontroller.imageurl = TableData[SelectedIndexPath.row].image!
            //print(TableData[SelectedIndexPath.row].image)
            // noticeDetailViewController.titlee = notish[SelectedIndexPath.row].valueForKey("title") as? String
            // noticeDetailViewController.messagee = notish[SelectedIndexPath.row].valueForKey("message") as? NSAttributedString
            
        }
    }
    
}





/*
 
 import UIKit
 var gid = 0
 
 class imgController: UIViewController , UITableViewDelegate, UITableViewDataSource{
 let json_dataa:String = "http://nbulletin.com/api/client/gallery?api_token="//3"
 let clid = "a1"
 // var image_base_url = "http://www.kaleidosblog.com/tutorial/"
 // var json_data_url:String = ViewController.clid  // ViewController.clid
 //var test = json_datas
 /// json_data_url.insert(
 var json_data_url:String = ""
 var TableData:Array < datastruct > = Array < datastruct >()
 //var Imagy:Array < UIImage > = Array < UIImage >()
 //var covimg:coverimg?
 //http:\/\/coopkhabar.com\/v1\/index.php\/..\/..\/file\/lpt-cooperative\/slider\/20160725133045.jpg","http:\/\/coopkhabar.com\/v1\/index.php\/..\/..\/file\/lpt-cooperative\/slider\/20160725133531.jpg","http:\/\/coopkhabar.com\/v1\/index.php\/..\/..\/file\/lpt-cooperative\/slider\/20160725133726.jpg","http:\/\/coopkhabar.com\/v1\/index.php\/..\/..\/file\/lpt-cooperative\/slider\/20160725133835.jpg"],"count":7}
 
 @IBOutlet weak var tableView: UITableView!
 @IBOutlet weak var menubtn: UIBarButtonItem!
 enum ErrorHandler:ErrorType
 {
 case ErrorFetchingResults
 }
 var img:UIImage? = nil
 struct datastruct
 {
 var id:Int?
 
 var title:String?
 var cover_image:String?
 var updated_at:String?
 //  var description:String?
 var image:UIImage? = nil
 
 init(add: NSDictionary)
 {
 id = add["id"] as? Int
 title    = add["title"] as? String
 cover_image    = add["cover_image"] as? String
 updated_at = add["updated_at"] as? String
 //  count = add["count"] as? String
 
 //    imageurl = add["image"] as? String
 //print(message)
 //  description = add["description"] as? String
 }
 }
 
 /* func addi()
 {
 json_data_url = json_dataa + gid
 json_data_url = json_data_url + urldash
 json_data_url = json_data_url + clid
 
 }*/
 func addi()
 {
 json_data_url = json_dataa + clid
 
 }
 
 @IBAction func reloadaction(sender: AnyObject) {
 TableData.removeAll()
 get_data_from_url(json_data_url)
 
 
 do_table_refresh()
 }
 
 override func viewDidLoad() {
 super.viewDidLoad()
 addi()
 get_data_from_url(json_data_url)
 print("test viw")
 tableView.dataSource = self
 tableView.delegate = self
 
 
 self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
 self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
 ///   get_data_from_url(json_data_url)
 //n.loadnotices()
 // fetch()
 //  ImageSlider.animationImages = [ img1, img2, img3]
 menubtn.target = self.revealViewController()
 menubtn.action = #selector(SWRevealViewController.revealToggle(_:))
 
 // tableView.rowHeight = UITableViewAutomaticDimension
 // tableView.estimatedRowHeight = 140
 
 
 // Uncomment the following line to preserve selection between presentations
 // self.clearsSelectionOnViewWillAppear = false
 
 // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
 // self.navigationItem.rightBarButtonItem = self.editButtonItem()
 }
 
 override func didReceiveMemoryWarning() {
 super.didReceiveMemoryWarning()
 // Dispose of any resources that can be recreated.
 }
 
 // MARK: - Table view data source
 func numberOfSections(in tableView: UITableView) -> Int {
 // #warning Incomplete implementation, return the number of sections
 return 1
 }
 func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
 {
 let cell = tableView.dequeueReusableCellWithIdentifier( "cell", forIndexPath: indexPath) as! galleryTableViewCell
 
 let data = TableData[indexPath.row]
 
 
 cell.cellTitle.text = data.title
 loadImageFromUrl(data.cover_image!, view: cell.cellCover)
 //cell.cellSubtitle?.attributedText = data.attmsg
 cell.cellUpdated?.text = data.updated_at
 
 //cell.textLabel?.text = data.title
 // cell.detailTextLabel?.text = data.message
 // print(data.title)
 
 return cell
 
 }
 
 func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
 {
 return TableData.count
 
 }
 func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
 
 
 let selectedRow = TableData[indexPath.row]
 gid = selectedRow.id!
 // gid = selectedRow.id!
 
 // let destinationVC = NoticeDetailViewController()
 //destinationVC.IData = selectedRow
 
 // destinationVC.performSegueWithIdentifier("NoticeDetailSegue", sender:self)
 
 }
 // gid = selectedRow.id!
 
 /*let destinationVC = NoticeDetailViewController()
 destinationVC.IData = selectedRow
 
 destinationVC.performSegueWithIdentifier("NoticeDetailSegue", sender:self)
 
 */
 
 
 
 
 func loadImageFromUrl(url: String, view: UIImageView){
 
 // Create Url from string
 let url = NSURL(string: url)!
 
 // Download task:
 // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
 let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
 // if responseData is not null...
 if let data = responseData{
 
 // execute in UI thread
 dispatch_async(dispatch_get_main_queue(), { () -> Void in
 view.image = UIImage(data: data)
 //    img = UIImage(<#T##NSData#>data: )
 })
 }
 }
 
 // Run task
 task.resume()
 }
 
 
 
 func get_data_from_url(url:String)
 {
 
 
 let url:NSURL = NSURL(string: url)!
 let session = NSURLSession.sharedSession()
 
 let request = NSMutableURLRequest(URL: url)
 request.HTTPMethod = "GET"
 request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
 
 
 let task = session.dataTaskWithRequest(request) {
 (
 let data, let response, let error) in
 
 guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
 print("error")
 
 return
 }
 print(data)
 
 dispatch_async(dispatch_get_main_queue(), {
 self.extract_json(data!)
 return
 })
 
 }
 
 task.resume()
 
 }
 
 
 func extract_json(jsonData:NSData)
 {
 print("extract_json function")
 let json: AnyObject?
 do {
 //  print("uoto let json")
 
 json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
 print(json)
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
 /*   else {
 if let jsonString = NSString(data: JSONData, encoding: NSUTF8StringEncoding) {
 println("JSON String: \n\n \(jsonString)")
 }
 fatalError("JSON does not contain a dictionary \(json)")
 }
 }
 else {
 fatalError("Can't parse JSON \(error)")
 }
 }
 else {
 fatalError("JSONData is nil")
 }*/
 //        print("JSON String: \n\n \(jsonString)")
 // print(list)
 //print(list.count)
 //  print("uoto if list =json loop")
 
 // var dataDictionary  = NSJSONSerialization.JSONObjectWithData(dataInput, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSDictionary
 
 let gallery: NSArray = list["gallery"]! as! NSArray
 // let coverimage:NSArray = list["coverimage"] as! NSArray
 //print(coverimage)
 
 for galleries in gallery{//
 let glry = galleries as! NSDictionary
 // let cid = not["message"]
 TableData.append(datastruct(add: glry))
 
 // print(TableData  )
 }
 print(TableData)
 
 /*
 for coverimages in coverimage{
 let imgg = coverimages as! NSString
 covimg?.coverimage = imgg["coverimage"] as? String
 //imgg as String
 print(imgg)
 }*/
 
 do
 {
 
 //    try read()
 }
 //    catch
 //               {
 //     }
 
 do_table_refresh()
 
 }
 
 
 }
 
 func do_table_refresh()
 {
 dispatch_async(dispatch_get_main_queue(), {
 self.tableView.reloadData()
 return
 })
 }
 
 
 // class Notices : UIViewController, UITableViewDataSource, UITableViewDelegate {
 
 
 
 
 
 
 
 
 
 /* func load_image(urlString:String, imageview:UIImageView, index:NSInteger)
 {
 
 let url:NSURL = NSURL(string: urlString)!
 let session = NSURLSession.sharedSession()
 
 let task = session.downloadTaskWithURL(url) {
 (
 let location, let response, let error) in
 
 guard let _:NSURL = location, let _:NSURLResponse = response  where error == nil else {
 print("error")
 return
 }
 
 let imageData = NSData(contentsOfURL: location!)
 
 dispatch_async(dispatch_get_main_queue(), {
 
 
 self.TableData[index].image = UIImage(data: imageData!)
 //      self.save(index,image: self.TableData[index].image!)
 
 imageview.image = self.TableData[index].image
 return
 })
 
 
 }
 
 task.resume()
 
 
 }*/
 
 
 
 
 
 
 }
 */



/*
import UIKit
//let gid = ""

class imageViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    let json_dataa:String = "http://nbulletin.com/api/client/gallery/"//3"
    let clid = "a1"
    let urldash = "?api_token="
    // var image_base_url = "http://www.kaleidosblog.com/tutorial/"
    // var json_data_url:String = ViewController.clid  // ViewController.clid
    //var test = json_datas
    /// json_data_url.insert(
    var json_data_url:String = ""
    var TableData:Array < datastruct > = Array < datastruct >()
    //var Imagy:Array < UIImage > = Array < UIImage >()
    //var covimg:coverimg?
    //http:\/\/coopkhabar.com\/v1\/index.php\/..\/..\/file\/lpt-cooperative\/slider\/20160725133045.jpg","http:\/\/coopkhabar.com\/v1\/index.php\/..\/..\/file\/lpt-cooperative\/slider\/20160725133531.jpg","http:\/\/coopkhabar.com\/v1\/index.php\/..\/..\/file\/lpt-cooperative\/slider\/20160725133726.jpg","http:\/\/coopkhabar.com\/v1\/index.php\/..\/..\/file\/lpt-cooperative\/slider\/20160725133835.jpg"],"count":7}
 
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menubtn: UIBarButtonItem!
    enum ErrorHandler:ErrorType
    {
        case ErrorFetchingResults
    }
    var img:UIImage? = nil
    struct datastruct
    {
        var id:String?
        var image:String?
        var thumb:String?
        var updated_at:String?
        //  var description:String?
 
        init(add: NSDictionary)
        {
            id = add["id"] as? String
            image    = add["image"] as? String
            thumb    = add["thumb"] as? String
            updated_at = add["updated_at"] as? String
            //  count = add["count"] as? String
 
            //    imageurl = add["image"] as? String
            //print(message)
            //  description = add["description"] as? String
        }
    }
    func addi()
    {
        json_data_url = json_dataa + (String(gid))
        json_data_url = json_data_url + urldash
        json_data_url = json_data_url + clid
 
    }
 
    @IBAction func reloadaction(sender: AnyObject) {
        TableData.removeAll()
        get_data_from_url( json_data_url)
 
 
        do_table_refresh()
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        addi()
        get_data_from_url( json_data_url)
 
        //tableView.dataSource = self
        //tableView.delegate = self
        
        // tableView.rowHeight = UITableViewAutomaticDimension
        // tableView.estimatedRowHeight = 140
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier( "cell", forIndexPath: indexPath) as! imageTableViewCell
        
        let data = TableData[indexPath.row]
        
        
        //cell.cellTitle.text = data.title
        loadImageFromUrl(data.thumb!, view: cell.cellImage)
        //cell.cellSubtitle?.attributedText = data.attmsg
        cell.cellUpdated?.text = data.updated_at
        
        //cell.textLabel?.text = data.title
        // cell.detailTextLabel?.text = data.message
        // print(data.title)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return TableData.count
        
    }

    /* func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
     
     let selectedRow = TableData[indexPath.row]
     
     let destinationVC = NoticeDetailViewController()
     destinationVC.IData = selectedRow
     
     destinationVC.performSegueWithIdentifier("NoticeDetailSegue", sender:self)
     }
     
     */
    
    
    
    
    
    func loadImageFromUrl(url: String, view: UIImageView){
        
        // Create Url from string
        let url = NSURL(string: url)!
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    view.image = UIImage(data: data)
                    //    img = UIImage(<#T##NSData#>data: )
                })
            }
        }
        
        // Run task
        task.resume()
    }
    
    
    
    func get_data_from_url(url:String)
    {
        
        
        let url:NSURL = NSURL(string: url)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                
                return
            }
            //     print(data)
            
            dispatch_async(dispatch_get_main_queue(), {
                self.extract_json(data!)
                return
            })
            
        }
        
        task.resume()
        
    }
    
    
    func extract_json(jsonData:NSData)
    {
        print("extract_json function")
        let json: AnyObject?
        do {
            //  print("uoto let json")
            
            json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
            print(json)
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
            /*   else {
             if let jsonString = NSString(data: JSONData, encoding: NSUTF8StringEncoding) {
             println("JSON String: \n\n \(jsonString)")
             }
             fatalError("JSON does not contain a dictionary \(json)")
             }
             }
             else {
             fatalError("Can't parse JSON \(error)")
             }
             }
             else {
             fatalError("JSONData is nil")
             }*/
            //        print("JSON String: \n\n \(jsonString)")
            //   print(list)
            //print(list.count)
            //print("uoto if list =json loop")
            
            // var dataDictionary  = NSJSONSerialization.JSONObjectWithData(dataInput, options: NSJSONReadingOptions.MutableContainers, error: &error) as? NSDictionary
            let gallery: NSArray = list["gallery"]! as! NSArray
            // let coverimage:NSArray = list["coverimage"] as! NSArray
            //print(coverimage)
            
            for galleries in gallery{//
                let glry = galleries as! NSDictionary
                // let cid = not["message"]
                TableData.append(datastruct(add: glry))
                // print(TableData  )
            }
            print(TableData)
            //    catch
            //               {
            //     }
            
            do_table_refresh()
            
        }
        
        
    }
    
    
    func do_table_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
    
    
    
    // class Notices : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    
    
    
    
    
    
    /* func load_image(urlString:String, imageview:UIImageView, index:NSInteger)
     {
     
     let url:NSURL = NSURL(string: urlString)!
     let session = NSURLSession.sharedSession()
     
     let task = session.downloadTaskWithURL(url) {
     (
     let location, let response, let error) in
     
     guard let _:NSURL = location, let _:NSURLResponse = response  where error == nil else {
     print("error")
     return
     }
     
     let imageData = NSData(contentsOfURL: location!)
     
     dispatch_async(dispatch_get_main_queue(), {
     
     
     self.TableData[index].image = UIImage(data: imageData!)
     //      self.save(index,image: self.TableData[index].image!)
     
     imageview.image = self.TableData[index].image
     return
     })
     
     
     }
     
     task.resume()
     
     
     }*/
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "imageDetailSegue"){
            let SelectedIndexPath:NSIndexPath = self.tableView.indexPathForSelectedRow!
            let imgdetailviewcontroller:detimgViewController = segue.destinationViewController as! detimgViewController
            //noticeDetailViewController.IData = notis[SelectedIndexPath.row]
            imgdetailviewcontroller.imageurl = TableData[SelectedIndexPath.row].image!
            print(TableData[SelectedIndexPath.row].image)
           // noticeDetailViewController.titlee = notish[SelectedIndexPath.row].valueForKey("title") as? String
           // noticeDetailViewController.messagee = notish[SelectedIndexPath.row].valueForKey("message") as? NSAttributedString
            
        }
    }
    
    
    
    
    
    
}*/

