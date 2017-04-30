//
//  Abouts.swift
//  slider
//
//  Created by leading on 7/7/16.
//  Copyright © 2016 leading. All rights reserved.
//
import MapKit
import Foundation

class Abouts : UIViewController {
    
    
    var json_dataa = "demo.nbulletin.com/api/v1/about?api_key=a1"
    // var image_base_url = "http://www.kaleidosblog.com/tutorial/"
    var json_data_url:String = ""
    
    var btntrk:Bool = true
    @IBOutlet weak var callbtn: UIButton!
    @IBOutlet weak var emailbtn: UIButton!
    @IBOutlet weak var sitebtn: UIButton!
    @IBOutlet weak var locbtn: UIButton!
    @IBOutlet weak var mnubtn: UIButton!
    
    
    @IBOutlet weak var clientaddress: UILabel!
    @IBOutlet weak var clientphone: UILabel!
    @IBOutlet weak var clientwebsite: UILabel!
 //   @IBOutlet weak var webb: UIWebView!
    @IBOutlet weak var clientimage: UIImageView!
    @IBOutlet weak var clientabout: UILabel!
    @IBOutlet weak var clientname: UILabel!
    @IBOutlet weak var menubtn: UIBarButtonItem!
    var TableData:Array < datastruct > = Array < datastruct >()
    var ImageData:Array < datastruct > = Array < datastruct >()
    //
    //http:\/\/coopkhabar.com\/v1\/index.php\/..\/..\/file\/lpt-cooperative\/slider\/20160725133045.jpg","http:\/\/coopkhabar.com\/v1\/index.php\/..\/..\/file\/lpt-cooperative\/slider\/20160725133531.jpg","http:\/\/coopkhabar.com\/v1\/index.php\/..\/..\/file\/lpt-cooperative\/slider\/20160725133726.jpg","http:\/\/coopkhabar.com\/v1\/index.php\/..\/..\/file\/lpt-cooperative\/slider\/20160725133835.jpg"],"count":7}
    
    let regionRadius: CLLocationDistance = 1000
    var initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
    var img:UIImage? = nil
    var name:String?
    var about:String?
    var latitude:String?
    var longitude:String?
    
    struct datastruct
    {
        var cid:String?
        var name:String?
          var email:String?
           var contact:String?
         var logo:String?
        var about:String?
        var website:String?
        var latitude:String?
        var longitude:String?
        
        init(add: NSDictionary)
        {
            cid = add["cid"] as? String
            name = add["name"] as? String
            email = add["email"] as? String
            contact = add["contact"] as? String
            logo = add["logo"] as? String
            about = add["about"] as? String
            website = add["website"] as? String
            latitude = add["latitude"] as? String
            longitude = add["longitude"] as? String
            
            
            //  description = add["description"] as? String
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
         get_data_from_url(url: abouturl)
        //callbtn.target(forAction: #selector(self.callaction), withSender: UIButton())
        // callbtn.target = self
       // callbtn.action = #selector
        //clientname?.text = ""
       // clientabout?.text = ""
       // print(clientname.text)
        menubtn.target = self.revealViewController()
        menubtn.action = #selector(SWRevealViewController.revealToggle(_:))
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        //UIWebView.loadRequest(webb)(NSURLRequest(URL: NSURL(string: "http://nbulletin.nliverary.com")!))
      //  initialLocation = CLLocation(latitude: Double(latitude!)!, longitude: Double(longitude!)!)
     //   centerMaponLocation(location: initialLocation)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        clientname.text = appname
        clientabout.text = ""
        clientphone.text = appphone
        clientaddress.text = appaddress
        clientwebsite.text = appwebsite
        
        locbtn.isHidden = true
        sitebtn.isHidden = true
        callbtn.isHidden = true
        // locbtn.isHidden = true
        emailbtn.isHidden = true
        mnubtn.isHidden = true
        
    }
    func callaction(){
        
        if let url = URL(string: "tel://\(clientphone.text!)"), UIApplication.shared.canOpenURL(url){
            UIApplication.shared.openURL(url)
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
                print("error?")
                
                return
            }
            //print(data)
            
            DispatchQueue.main.async(execute: {
                self.extract_json(jsonData: data! as NSData)
                return
            })
            
        }
        //tableView.reloadData()
        task.resume()
        //loadnoticefromcoredata()
        
    }
 
    @IBAction func menubtnpush(_ sender: Any) {
        if btntrk == true {
            UIView.animate(withDuration: 0.8, animations: {
                self.locbtn.alpha = 0
                self.sitebtn.alpha = 0
                self.callbtn.alpha = 0
                self.emailbtn.alpha = 0
            })
            
            locbtn.isHidden = true
            sitebtn.isHidden = true
            callbtn.isHidden = true
           // locbtn.isHidden = true
            emailbtn.isHidden = true
            btntrk = false
            
            
            
        }
        else {
            
            locbtn.isHidden = false
            sitebtn.isHidden = false
            callbtn.isHidden = false
           // locbtn.isHidden = false
            emailbtn.isHidden = false
            btntrk = true
            
            
            UIView.animate(withDuration: 0.8, animations: {
                self.locbtn.alpha = 1.0
                self.sitebtn.alpha = 1.0
                self.callbtn.alpha = 1.0
                self.emailbtn.alpha = 1.0
            })
            
        }
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
        {
            let client: NSDictionary = list["about"]! as! NSDictionary
           // for clients in client{
               // let clnt = clients as! NSDictionary
                clientname?.text = client["organization_name"] as? String
                clientwebsite?.text = client["website"] as? String
                clientphone?.text = client["contact"] as? String
                clientaddress?.text = client["address"] as? String
                let attmsg: NSAttributedString
                attmsg = try! NSAttributedString(data: ((client["description"] as? String)!.data(using: String.Encoding.unicode, allowLossyConversion: true)!), options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil )
                
                
                clientabout?.attributedText = attmsg
                
               // longitude = (clnt["longitude"] as? String)// TableData.append(datastruct(add: clnt))
               // latitude = (clnt["latitude"] as? String)
                //print(latitude , longitude)
                
                clientname.sizeToFit()
               // clientabout.sizeToFit()
                //print(clnt["logo"] as? String)
                
               // clientimage.af_setImage(withURL: URL(string: clnt["logo"]! as! String)!)
               // loadImageFromUrl( (clnt["logo"] as? String)! , view: clientimage)
                
                
                // print(res)
            //    initialLocation = CLLocation(latitude: Double(latitude!)!, longitude: Double(longitude!)!)
                
            //    centerMaponLocation(location: initialLocation)
                
                
            
            
    }
    
    
    /*func read() throws
    {
    
    do
    {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedContext = appDelegate.managedObjectContext!
    let fetchRequest = NSFetchRequest(entityName: "Images")
    
    let fetchedResults = try managedContext.executeFetchRequest(fetchRequest)
    
    for (var i=0; i < fetchedResults.count; i++)
    {
    let single_result = fetchedResults[i]
    let index = single_result.valueForKey("index") as! NSInteger
    let img: NSData? = single_result.valueForKey("image") as? NSData
    
    TableData[index].image = UIImage(data: img!)
    
    }
    
    }
    catch
    {
    print("error")
    throw ErrorHandler.ErrorFetchingResults
    }
    
    }
    
    func save(id:Int,image:UIImage)
    {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedContext = appDelegate.managedObjectContext!
    
    let entity = NSEntityDescription.entityForName("Images",
    inManagedObjectContext: managedContext)
    let options = NSManagedObject(entity: entity!,
    insertIntoManagedObjectContext:managedContext)
    
    let newImageData = UIImageJPEGRepresentation(image,1)
    
    options.setValue(id, forKey: "index")
    options.setValue(newImageData, forKey: "image")
    
    do {
    try managedContext.save()
    } catch
    {
    print("error")
    }
    
    }
    
    */
    
    
    // MARK: - Table view data source
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
    
    // Configure the cell...
    
    return cell
    }
    */
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    func prepareForSegue(segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        // if(segue.identifier == "NoticeDetailSegue"){
        //   let SelectedIndexPath:NSIndexPath = self.tableView.indexPathForSelectedRow!
        // let noticeDetailViewController:NoticeDetailViewController = segue.destinationViewController as! NoticeDetailViewController
        //  resourceDetailViewController.IData = TableData[SelectedIndexPath.row]
        
        
    }
    
}
}
