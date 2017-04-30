//
//  leaveRequestViewController.swift
//  nBulletin
//
//  Created by beependra on 4/11/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Alamofire
import TTGSnackbar


class leaveRequestViewController: UIViewController {

    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var toText: UITextField!
    @IBOutlet weak var fromText: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    let apiToken = datadef.object(forKey: "studentToken") as? String
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        descriptionText.layer.borderColor = primaryColor.cgColor
        descriptionText.layer.borderWidth = 1
        descriptionText.layer.cornerRadius = 5
        
        
        toText.layer.borderColor = primaryColor.cgColor
        toText.layer.borderWidth = 1
        toText.layer.cornerRadius = 5
        
        fromText.layer.borderColor = primaryColor.cgColor
        fromText.layer.borderWidth = 1
        fromText.layer.cornerRadius = 5
        
        
        submitBtn.layer.cornerRadius = 5
        submitBtn.layer.borderWidth = 2
        submitBtn.layer.borderColor = primaryColor.cgColor
        
        
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        let datePickerView1:UIDatePicker = UIDatePicker()
        datePickerView1.datePickerMode = UIDatePickerMode.date
        toText.inputView = datePickerView
        fromText.inputView = datePickerView1
        datePickerView.addTarget(self, action: #selector(leaveRequestViewController.datePickerValueChanged1), for: UIControlEvents.valueChanged)
        datePickerView1.addTarget(self, action: #selector(leaveRequestViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        // Do any additional setup after loading the view.
    }

    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        // dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // dateFormatter.timeStyle = DateFormatter.Style.none
        
        fromText.text = dateFormatter.string(from: sender.date)
        if toText.text != "" && fromText.text != ""{
            //filterBtn.isHidden = false
        }
        else{
           // filterBtn.isHidden = true
        }
        
    }
    func datePickerValueChanged1(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        // dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // dateFormatter.timeStyle = DateFormatter.Style.none
        
        toText.text = dateFormatter.string(from: sender.date)
        if toText.text != "" && fromText.text != ""{
          //  filterBtn.isHidden = false
        }
        else{
           // filterBtn.isHidden = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        //let headers = [
        //            "access-token": accessToken,
        //            "encryption": encry
        //]
        if fromText.text == "" || toText.text == "" || descriptionText.text == "" {
//            let snackbar = TTGSnackbar.init(message: "Enter Subject and Message", duration: .middle)
//            snackbar.show()
            
        }
        else{
            if let to = toText.text {
                if let from = fromText.text{
                    if let desc = descriptionText.text
                    {
                    //  print("btnpressa")
                        sendLeaveRequest(to : to, from : from, desc : desc)
                
                    }
                }
                    
                else{
                    //passField.placeholder = "Enter Password"
                }
            }
            else{
                //userField.placeholder = "Enter Usasername"
            }
            
        }
        
        
        
        
        
        
        
    }
    func sendLeaveRequest(to:String, from:String, desc:String){
        
        let parameters = [
            //            "name" : data.value(forKey: "name") as! String,
            //            "email" : data.value(forKey: "username") as! String,
            //            "subject" : subject,
            //            "phone" : data.value(forKey: "phone") as! String,
            //            "message" : message
            // "date" : result
            "start_at" : from,
            "end_at" : to,
            "description" : desc
            
        ]
        print(parameters)
        let requestString = "\(leaveRequesturl)\(apiToken!)"
        print(requestString)
        
        // Both calls are equivalent
        Alamofire.request(requestString, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
            response in //debugPrint(response)
            
            // print(response.request)  // original URL request
            // print(response.response) // HTTP URL response
            //print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                
                if    let list = JSON as? NSDictionary// NSArray
                {
                    if let error:Bool = list["error"] as? Bool{
                        if error == false {
                            // print(datadef.object(forKey: "datadic"))
                           // _ = self.navigationController?.popViewController(animated: true)
                            let snackbar = TTGSnackbar.init(message: list["msg"] as! String, duration: .middle)
                            snackbar.show()
                            _ = self.navigationController?.popViewController(animated: true)
                            
                        }
                        else{
                            print("noauth")
                            
                            let snackbar = TTGSnackbar.init(message: "Could not send Notice", duration: .middle)
                            snackbar.show()
                        }
                        
                    }
                    else{
                        //success = false
                        
                        
                        let snackbar = TTGSnackbar.init(message: "Server Error", duration: .middle)
                        snackbar.show()
                        
                    }
                }
                
            }
            else{
                let snackbar = TTGSnackbar.init(message: "Unable to Connect to Server", duration: .middle)
                snackbar.show()
                
            }
        }
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
