//
//  ViewController.swift
//  fscalenderr
//
//  Created by beependra on 12/14/16.
//  Copyright © 2016 beependra. All rights reserved.
//
//
//  
import SystemConfiguration
import CoreData
import UIKit
import FSCalendar
import EventKit

class calendarController: UIViewController , FSCalendarDelegate , FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource {
    
    
    
    //let eventurl:String = "http://demo.nbulletin.com/api/v1/event?api_token=a1"
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var TableData:Array < datastruct > = Array < datastruct >()
    var edict = ["id": 0, "title": "","description" : "","start_time" : "","end_time" : "", "start_date" : "", "end_date" : "", "is_all_day" : 0, "background_color" : ""] as [String : Any]
    //let dict = edict as! NSDictionary
    var TData: datastruct = datastruct(add:["id":0])
    
    
   // let json_dataa:String = "demo.nbulletin.com/api/v1/event?api_token=a1"//"http://nbulletin.com/api/client/event?api_token=a1"//3"
    var clid:String = "1"
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet var reloadbtn:UIBarButtonItem!
    
    
  //  var json_data_url:String = ""
    
    @IBOutlet weak var menubtn: UIBarButtonItem!
    enum ErrorHandler:Error
    {
        case ErrorFetchingResults
    }
    var img:UIImage? = nil
    struct datastruct
    {
        var id:Int16?
        var title:String?
        var start_date:String?
        var end_date:String?
        //   var tag:String?
        var end_time:String?
        var start_time:String?
        var is_all_day:Int16?
        var background_color:String?
        var descripton:String?
        //   var count:String?
        init(add: NSDictionary)
        {
            id = add["id"] as? Int16
            title    = add["title"] as? String
            start_date = add["start_date"] as? String
            //     tag   = add["tag"] as? String
            end_date = add["end_date"] as? String
            start_time  = add["start_time"] as? String
            end_time  = add["end_time"] as? String
            is_all_day   = add["is_all_day"] as? Int16
            background_color = add["background_color"] as? String
            descripton = add["description"] as? String
            //  count = add["count"] as? String
            
            //    imageurl = add["image"] as? String
            //print(message)
            //  description = add["description"] as? String
        }
    }
    
    
    @IBAction func reloadaction(sender: AnyObject) {
        TableData.removeAll()
        get_data_from_url(url: eventurl)
        
        
        do_table_refresh()
    }
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    private let formater: DateFormatter = {
        let formater = DateFormatter()
        formater.dateFormat = "MM-yyyy-dd"
        return formater
    }()
    private let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)

    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //addi()
        if revealViewController() != nil {
            //            revealViewController().rearViewRevealWidth = 62
            menubtn.target = revealViewController()
            menubtn.action = #selector(SWRevealViewController.revealToggle(_:))
            
            //revealViewController().rightViewRevealWidth = 150
            //extraButton.target = revealViewController()
            //extraButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
            
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 240
        
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
            loadeventfromcoredata()
            
            clearCoreData(entity: "Event")
            
            loadeventfromurl()
            
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
            loadeventfromcoredata()
            
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
            
            let event: NSArray = list["event"]! as! NSArray
            // let coverimage:NSArray = list["coverimage"] as! NSArray
            //print(coverimage)
            
            for events in event{//
                let evnt = events as! NSDictionary
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
                store(dataset: datastruct(add: evnt))
                
                //   TableData.append(datastruct(add: sty))
                // print(TableData)
            }
            
            loadeventfromcoredata()
            
        }
        
        
    }
    func store (dataset: datastruct) {
        
        
        
        //retrieve the entity that we just created
        let appDel:AppDelegate = (UIApplication.shared.delegate) as! AppDelegate
        
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        
        //2
        let newdata = NSEntityDescription.insertNewObject(forEntityName: "Event", into: context) as NSManagedObject
        
       // print(dataset)
        //set the entity values
        newdata.setValue(dataset.id, forKey: "id")
        newdata.setValue(dataset.title , forKey: "title")
        newdata.setValue(dataset.start_date, forKey: "start_date")
        newdata.setValue(dataset.end_date, forKey: "end_date")
        newdata.setValue(dataset.start_time, forKey: "start_time")
        newdata.setValue(dataset.end_time, forKey: "end_time")
        newdata.setValue(dataset.is_all_day, forKey: "is_all_day")
        newdata.setValue(dataset.descripton, forKey: "descripson")
        newdata.setValue(dataset.background_color, forKey: "background_color")
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
    
    func loadeventfromurl(){
        get_data_from_url(url: eventurl)
        
    }
    func loadeventfromcoredata(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        let appDel:AppDelegate = (UIApplication.shared.delegate) as! AppDelegate
        
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Event", in: context)
        fetchRequest.includesPropertyValues = false
        do {
            if let results = try context.fetch(fetchRequest) as? [NSManagedObject] {
                
                print(results.count)
                TableData.removeAll()
                for result in results {
                    edict["id"] = result.value(forKey: "id") as? Int16
                    edict["title"] = result.value(forKey: "title") as? String
                    edict["descripton"] = result.value(forKey: "descripson") as? String
                    edict["start_date"] = result.value(forKey: "start_date") as? String
                    edict["end_date"] = result.value(forKey: "end_date") as? String
                    edict["start_time"] = result.value(forKey: "start_time") as? String
                    edict["end_time"] = result.value(forKey: "end_time") as? String
                    edict["background_color"] = result.value(forKey: "background_color") as? String
                    edict["is_all_day"] = result.value(forKey: "is_all_day") as? String
                    
                    
                    
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! calendarTableViewCell
        
        let data = TableData[indexPath.row]
        //print(data)
        
        cell.cellTitle?.text = data.title
        cell.cellSubtitle?.text = data.descripton
        cell.celldate.textColor = primaryColor
        cell.cellDatee.textColor = primaryColor
        
        
        var datearr = data.start_date?.components(separatedBy: " ")
        let index = datearr?[0].index((datearr?[0].startIndex)!, offsetBy: 7)
        cell.cellDatee.text = datearr?[0].substring(to: index!)
        cell.celldate.text = ("\((datearr?[0][8])!)\((datearr?[0][9])!)")
        
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
        print("eventclear")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("tablecount")
        
        //print(TableData.count)
        
        return TableData.count
        
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alrt = UIAlertController(title: "Event", message: "add this event to your calendar?", preferredStyle: .actionSheet)
        alrt.addAction(UIAlertAction(title: "Add to Calendar", style: .default){ action in
            
            self.calendar.select(self.formatter.date(from: self.TableData[indexPath.row].start_date!)!)
            self.addEventToCalendar(title: self.TableData[indexPath.row].title!, description: self.TableData[indexPath.row].descripton!, startDate: self.formatter.date(from:  (self.TableData[indexPath.row].start_date)!)! as NSDate, endDate: self.formatter.date(from:  (self.TableData[indexPath.row].end_date)!)! as NSDate)
            
            
        })
        alrt.addAction(UIAlertAction(title: "Cancel", style: .default){ action in
        alrt.dismiss(animated: true, completion: { 
            
        })
            
        })
        self.present(alrt, animated: true)
        
        
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
    
    
    
    
    func addEventToCalendar(title: String, description: String?, startDate: NSDate, endDate: NSDate, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate as Date
                event.endDate = endDate as Date
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
                print("event saved")
                
            } else {
                completion?(false, error as NSError?)
            }
        })
    }
    
    
    
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: "2015-01-01")!
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: "2017-12-31")!
    }
    
    /*func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let day: Int! = self.gregorian.component(.day, from: date)
        //return day % 5 == 0 ? day/5 : 0;
       // return day % 7
    }*/
    
    func calendar(_ calendar: FSCalendar, hasEventFor date: Date) -> Bool {
        var datesWithEvent:[NSDate] = []

        for datea in TableData{
            let order = NSCalendar.current.compare(formatter.date(from: datea.start_date!)!, to: formatter.date(from: datea.end_date!)!, toGranularity: .day)
            if order == ComparisonResult.orderedSame{
                let unitFlags: NSCalendar.Unit = [ .day, .month, .year]
                let calendar2: NSCalendar = NSCalendar.current as NSCalendar
                let components: NSDateComponents = calendar2.components(unitFlags, from: formatter.date(from: datea.start_date!)!) as NSDateComponents
                datesWithEvent.append(calendar2.date(from: components as DateComponents)! as NSDate)
                
            }
        }
        return datesWithEvent.contains(date as NSDate)

        //return true
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        NSLog("change page to \(self.formatter.string(from: calendar.currentPage))")
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        NSLog("calendar did select date \(self.formatter.string(from: date))")
        for i in 0..<TableData.count
        {
            if(TableData[i].start_date == (self.formatter.string(from: date)))
            {
            print("ys event")
                let rowToSelect:IndexPath = IndexPath(row: i, section: 0)  //slecting 0th row with 0th section
                self.tableView.selectRow(at: rowToSelect as IndexPath, animated: true, scrollPosition: UITableViewScrollPosition.middle)

            }
        }
        
       // if monthPosition == .previous || monthPosition == .next {
          //  calendar.setCurrentPage(date, animated: true)
       // }
    }

}


