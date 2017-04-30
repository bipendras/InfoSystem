//
//  Notices.swift
//  nBulletin
//
//  Created by leading on 7/8/16.
//  Copyright © 2016 leading. All rights reserved.
//

import UIKit
import CoreData

class Notices : UIViewController, UITableViewDataSource, UITableViewDelegate {
    //var TableData:Array < datastruct > = Array < datastruct >()
    var ImageData:Array < NSString > = Array < NSString >()
    var Imagy:Array < UIImage > = Array < UIImage >()
    var covimg:coverimg?
    var notish = notis//[NSManagedObject]()
    var n = loaddata()
    //http:\/\/coopkhabar.com\/v1\/index.php\/..\/..\/file\/lpt-cooperative\/slider\/20160725133045.jpg","http:\/\/coopkhabar.com\/v1\/index.php\/..\/..\/file\/lpt-cooperative\/slider\/20160725133531.jpg","http:\/\/coopkhabar.com\/v1\/index.php\/..\/..\/file\/lpt-cooperative\/slider\/20160725133726.jpg","http:\/\/coopkhabar.com\/v1\/index.php\/..\/..\/file\/lpt-cooperative\/slider\/20160725133835.jpg"],"count":7}
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ImageSlider: UIImageView!
    
    @IBOutlet weak var menubtn: UIBarButtonItem!
    enum ErrorHandler:ErrorType
    {
        case ErrorFetchingResults
    }
    var img:UIImage? = nil
    struct imgstruct
    {
        var image:String?
        init(addim: NSDictionary)
        {
            image = addim["image"] as? String
        }
    }
    struct coverimg
    {
        var coverimage:String?
        init(addim: NSDictionary)
        {
            coverimage = addim["coverimage"] as? String
        }
    }
    
    @IBAction func reloadaction(sender: AnyObject) {
       clearCoreData("Noticeentity")
        n.loadnotices()
        tableView.reloadData()
        //viewDidLoad()
         do_table_refresh()
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
     ///   get_data_from_url(json_data_url)
        //n.loadnotices()
       // fetch()
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
        //  ImageSlider.animationImages = [ img1, img2, img3]
        menubtn.target = self.revealViewController()
        menubtn.action = #selector(SWRevealViewController.revealToggle(_:))
        tableView.reloadData()
        do_table_refresh()
        //ImageSlider.animationDuration = 10
        //ImageSlider.startAnimating()
       
    if(covimg?.coverimage == nil)
    {
        
        }
        else
    {
        //loadImageFromUrl((covimg?.coverimage)!, view: ImageSlider!)
        }
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        //ImageSlider.image = img
        
    }
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
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! noticeTableViewCell
        
        let data = TableData[indexPath.row]
        
        
        cell.cellTitle.text = data.title! as String//data.valueForKey("title") as? String
        cell.cellSubtitle.text = data.message! as String//data.valueForKey("message") as? String//data.message
        //cell.cellSubtitle?.attributedText = data.attmsg
        cell.celldate?.text = data.day! as String//data.valueForKey("day") as? String//data.day
        cell.cellDatee?.text = data.month! as String// (data.valueForKey("year") as? String)!//data.month! + ","  + data.year!//data.valueForKey("month") as? String
        
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
    
    
    
    
    func clearCoreData(entity:String) {
        let fetchRequest = NSFetchRequest()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        print("clearing coredata")
        fetchRequest.entity = NSEntityDescription.entityForName(entity , inManagedObjectContext: managedContext!)
        fetchRequest.includesPropertyValues = false
        do {
            if let results = try managedContext!.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                for result in results {
                    managedContext!.deleteObject(result)
                }
                
                try managedContext!.save()
            }
        } catch {
            // LOG.debug("failed to clear core data")
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //fetch()
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
           // clearCoreData("Noticeentity")
           // notish.removeAll()
            print(notis)
           TableData.removeAll()
            clearCoreData("Noticeentity")
            n.loadnoticess()
            print(notis)
            tableView.reloadData()
            print(TableData)
           // do_table_refresh()
        } else {
            print("Internet connection FAILED")
            let alert = UIAlertView(title: "OOPS! No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            fetch()
            tableView.reloadData()
        }
        
        
       // fetch()
       // n.loadnotices()
        //1
            }
    func fetch(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        //2
        let fetchRequest = NSFetchRequest(entityName: "Noticeentity")
        //3
        do {
            let results = try managedContext!.executeFetchRequest(fetchRequest)
            notish = results as! [NSManagedObject]
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        print("fetchced notices")
        
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
    
    func do_table_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
    
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "NoticeDetailSegue"){
            let SelectedIndexPath:NSIndexPath = self.tableView.indexPathForSelectedRow!
            let noticeDetailViewController:NoticeDetailViewController = segue.destinationViewController as! NoticeDetailViewController
            //noticeDetailViewController.IData = notis[SelectedIndexPath.row]
            noticeDetailViewController.titlee = notish[SelectedIndexPath.row].valueForKey("title") as? String
            noticeDetailViewController.messagee = notish[SelectedIndexPath.row].valueForKey("message") as? NSAttributedString
            
        }
    }
    
}
