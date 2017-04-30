//
//  loginViewController.swift
//  nBulletin
//
//  Created by beependra on 2/20/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import CoreData
import TTGSnackbar
class loginViewController: UIViewController {

    @IBOutlet weak var userLabel: UITextField!
    @IBOutlet weak var passLabel: UITextField!
    
    @IBOutlet weak var dateLabel: UITextField!
    @IBOutlet weak var monthLabel: UITextField!
    
    struct datastruct
    {
        var full_name:String?
        var desc:String?
        var dob_ad:String?
        //   var tag:String?
        var dob_bs:String?
        var api_token:String?
        var contact:String?
        var image:String?
        var temporary_address:String?
        var permanent_address:String?
        //var attmsg:NSAttributedString
        init(add: NSDictionary)
        {
            full_name = add["full_name"] as? String
            desc    = add["description"] as? String
            dob_ad = add["dob_ad"] as? String
            dob_bs = add["dob_bs"] as? String
            api_token = add["api_token"] as? String
            contact = add["contact"] as? String
            temporary_address = add["temporary_address"] as? String
            image = add["image"] as? String
            permanent_address = add["permanent_address"] as? String
            //     tag   = add["tag"] as? String
            
        }
    }
    struct datastructclass
    {
        var name:String?
        var routine:String?
        init(add: NSDictionary)
        {
            name = add["name"] as? String
            routine    = add["routine"] as? String
            //     tag   = add["tag"] as? String
            
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        UITextField.connectFields(fields: [userLabel,monthLabel, dateLabel, passLabel])
        
    //    let datePickerView:UIDatePicker = UIDatePicker()
    //    datePickerView.datePickerMode = UIDatePickerMode.date
     //   userLabel.inputView = datePickerView
      //  datePickerView.addTarget(self, action: #selector(loginViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        // Do any additional setup after loading the view.
    }
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        // dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // dateFormatter.timeStyle = DateFormatter.Style.none
        
        userLabel.text = dateFormatter.string(from: sender.date)
        
    }


    @IBAction func loginBtn1(_ sender: Any) {
        sendToken(url: loginurl,user: userLabel.text!, pass: passLabel.text!)
        
    }
    @IBAction func loginBtn(_ sender: Any) {
       if userLabel.text == "" || monthLabel.text == "" || dateLabel.text == "" || passLabel.text == ""{
            let snackbar = TTGSnackbar.init(message: "Enter all Fields", duration: .middle)
            snackbar.show()
        
        }
       else{
        
        sendToken(url: loginurl,user: "\(userLabel.text!)-\(monthLabel.text!)-\(dateLabel.text!)", pass: passLabel.text!)
        }
    }
    
    func sendToken(url:String, user:String, pass:String)
    {
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        // if let tkn = tokenn! {
        print(user)
        print(pass)
        let postString = "username=\(user)&password=\(pass)"
        
        
        //print(tokenn)
        // }
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
           /* if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }*/
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            else {
            DispatchQueue.main.async(execute: {
                self.extract_json(jsonData: data as NSData)
                return
            })
                
            }
            //let responseString = String(data: data, encoding: .utf8)
            //print("responseString = \(responseString)")
        }
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
           // print(list)
           print(list)
            let error = list["error"] as! Bool
            if (error){
                let snackbar = TTGSnackbar.init(message: list["msg"] as! String, duration: .middle)
                snackbar.show()
                

            let profile: NSDictionary = list["student"]! as! NSDictionary //as! NSArray
            let clyass: NSDictionary = list["class"] as! NSDictionary
            
            // let coverimage:NSArray = list["coverimage"] as! NSArray
            //print(coverimage)
//            print(profile)
//            print(profile.allKeys)
//            print(profile.value(forKey: "full_name"))
//           // for galleries in gallery{//
              // print(full_name)
            //let glris = galleries as! NSDictionary
                // let cid = not["message"]
            datadef.set(profile.value(forKey: "api_token") , forKey: "studentToken")
            store(dataset: datastruct(add: profile), dataset1: datastructclass(add:clyass   ))
                ///chapter = ttl["chapter"] as? String
                /// body = ttl["body"] as? String
                ///  image = ttl["image"] as? String
                ///  chapterlabel.text = chapter
                ///  bodylabel.text = body
                ///loadImageFromUrl(url: image!, view: imagee)
                // print(sty.value(forKey: "id"))
                //print(nts)
                //print(datastruct(add:nts))
          //      store(dataset: datastruct(add: glris))
                
                //   TableData.append(datastruct(add: sty))
                // print(TableData)
           // }
            
          //  loadgalleryfromcoredata()
            }
            else{
                let profile: NSDictionary = list["student"]! as! NSDictionary //as! NSArray
                let clyass: NSDictionary = list["class"] as! NSDictionary
                
                // let coverimage:NSArray = list["coverimage"] as! NSArray
                //print(coverimage)
                //            print(profile)
                //            print(profile.allKeys)
                //            print(profile.value(forKey: "full_name"))
                //           // for galleries in gallery{//
                // print(full_name)
                //let glris = galleries as! NSDictionary
                // let cid = not["message"]
                datadef.set(clyass.value(forKey: "routine") as! String, forKey: "routine")
                datadef.set(profile.value(forKey: "api_token") , forKey: "studentToken")
                store(dataset: datastruct(add: profile), dataset1: datastructclass(add:clyass   ))
                ///chapter = ttl["chapter"] as? String
                /// body = ttl["body"] as? String
                ///  image = ttl["image"] as? String
                ///  chapterlabel.text = chapter
                ///  bodylabel.text = body
                ///loadImageFromUrl(url: image!, view: imagee)
                // print(sty.value(forKey: "id"))
                //print(nts)
                //print(datastruct(add:nts))
                //      store(dataset: datastruct(add: glris))
                
                //   TableData.append(datastruct(add: sty))
                // print(TableData)
                // }
                
                //  loadgalleryfromcoredata()
                if let resultController = storyboard!.instantiateViewController(withIdentifier: "dashboard") as? UINavigationController {
                    present(resultController, animated: true, completion: nil)
                    //loadAllData()
                }
                            }
        }
        
    }
    
    
    
    func store (dataset: datastruct,dataset1: datastructclass) {
        
        
        
        //retrieve the entity that we just created
        let appDel:AppDelegate = (UIApplication.shared.delegate) as! AppDelegate
        
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        
        //2
        let newdata = NSEntityDescription.insertNewObject(forEntityName: "Profile", into: context) as NSManagedObject
        print(dataset)
        //set the entity values
        
        newdata.setValue(dataset.api_token, forKey: "api_token")
        newdata.setValue(dataset.full_name , forKey: "full_name")
        newdata.setValue(dataset.contact , forKey: "contact")
        newdata.setValue(dataset.dob_ad, forKey: "dob_ad")
        newdata.setValue(dataset.dob_bs, forKey: "dob_bs")
        newdata.setValue(dataset.temporary_address  , forKey: "temporary_address")
        newdata.setValue(dataset.permanent_address  , forKey: "permanent_address")
        newdata.setValue(dataset.image, forKey: "image")
        newdata.setValue(dataset.desc, forKey: "desc")
        newdata.setValue(dataset1.name, forKey: "name")
        newdata.setValue(dataset1.routine, forKey: "routine")
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
        print("loginclear")
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

