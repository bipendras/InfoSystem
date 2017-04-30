//
//  diaryViewController.swift
//  nBulletin
//
//  Created by beependra on 4/11/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Alamofire
import TTGSnackbar

class diaryViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var diaries:Array<Any>?
    var myArray:Array<Any>? //= diaries.reversed() as Array
    
    var edittitle = ""
    var editdesc = ""
    override func viewDidLoad() {
        super.viewDidLoad()
       // myArray = diaries?.reversed()
        
        loadDiary()
        tableView.dataSource = self
        tableView.delegate = self
       // self.tableView.addSubview(self.refreshControl)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        //loginaccount()
        diaries = datadef.object(forKey: "diaries") as! Array?
        myArray = diaries?.reversed()
        tableView.reloadData()
        
      //  print(diaries)
    }
    func deleteDiary(id: Int){
        print(id)
        myArray?.remove(at: id)
        diaries = myArray?.reversed()
        datadef.set(diaries, forKey: "diaries")
        //myArray = diaries?.reversed()
         
        tableView.reloadData()
        
    }
    func editDiary(id: Int){
        let data = myArray?[id] as! NSDictionary
        print(data.value(forKey: "title") as! String?)
        edittitle = (data.value(forKey: "title") as! String?)! //as! String
        editdesc = (data.value(forKey: "description") as! String?)! //as! String
        //deleteDiary(id: id)
        
        performSegue(withIdentifier: "adddiary", sender: self)
        
        
    }
    func loadDiary() {
        
        // let data = datadef.object(forKey: "datadic") as! NSDictionary
        
        //if pinField.text! == String(describing: (data.value(forKey: "pin_code") as! Int?)!) {
        
        //        let headers = [
        //            "access-token": accessToken,
        //            "encryption": data.value(forKey: "encrypt") as! String
        //        ]
        //        print(headers)
        //        //        let parameters = [
        //            "username": user,
        //            "password": pass
        //
        //        ]
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let SelectedIndexPath:NSIndexPath = self.tableView.indexPathForSelectedRow! as NSIndexPath
        //        let data = accounts?[SelectedIndexPath.row] as! NSDictionary
        //
        //        datadef.set((data.value(forKey: "slug") as! String), forKey: "selectedAccount")
        //        self.switchToDataTab()
        //
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if myArray?.count == nil {
            return 0
        }
        else {
            return(myArray?.count)!
        }
        // return((accounts!.count)==nil?0:accounts!.count)
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {action in
            let data = self.myArray?[indexPath.row] as! NSDictionary
            //print(String(describing: data.value(forKey: "id")))
            print (data)
            self.deleteDiary(id: indexPath.row)
            self.loadDiary()
            self.tableView.reloadData()
            //handle delete
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") {action in
            //handle edit
            let data = self.myArray?[indexPath.row] as! NSDictionary
            //print(String(describing: data.value(forKey: "id")))
            print (data)
            self.editDiary(id: indexPath.row)
      //      self.loadDiary()
           // self.tableView.reloadData()

        }
        
        return [deleteAction, editAction]
        
    }
    
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //        if (editingStyle == UITableViewCellEditingStyle.insert) {
    //            // handle delete (by removing the data from your array and updating the tableview)
    //        }
    //    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        // 1. set the initial state of the cell
        cell.alpha = 0
        let transform = CATransform3DTranslate(CATransform3DIdentity, -250, 20, 0)
        cell.layer.transform = transform
        
        // 2. UIView animation method to change to the final state of the cell
        UIView.animate(withDuration: 0.3, animations: {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        })
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
        
        let data = myArray?[indexPath.row] as! NSDictionary
        cell.textLabel?.text = data.value(forKey: "title") as? String
        cell.detailTextLabel?.text = data.value(forKey: "description") as? String
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "adddiary"){
            //noticeDetailViewController.titlee = notish[SelectedIndexPath.row].value(forKey: "title") as? String
            // noticeDetailViewController.messagee = notish[SelectedIndexPath.row].value(forKey: "message") as? NSAttributedString
           // if let resultController = storyboard!.instantiateViewController(withIdentifier: "addNote") as? addDiaryViewController {
            let AddDiaryViewController:addDiaryViewController = segue.destination as! addDiaryViewController
                AddDiaryViewController.titl = edittitle
                AddDiaryViewController.note = editdesc
            
            //

                //popoverPresentationController(resultController)
                //  present(resultController, animated: true, completion: nil)
                //resultController.titleText =
                //loadAllData()
           // }
        }
        //        if(segue.identifier == "accountSeelected"){
        //            let SelectedIndexPath:NSIndexPath = self.tableView.indexPathForSelectedRow! as NSIndexPath
        //            let data = accounts?[SelectedIndexPath.row] as! NSDictionary
        //
        //            datadef.set((data.value(forKey: "slug") as! String), forKey: "selectedAccount")
        //
        //            let BalanceViewController:balanceViewController = segue.destination as! balanceViewController
        //            BalanceViewController.accounts = datadef.object(forKey: "clientAccounts") as! NSArray?
        //            BalanceViewController.encryp = datadef.object(forKey: "encrypt") as! String?
        //
        //
        //            BalanceViewController.selectedAccount = data.value(forKey: "slug") as? String
        //            BalanceViewController.loadBalance()
        //
        //
        //        }
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
