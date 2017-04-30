//
//  profileViewController.swift
//  nBulletin
//
//  Created by beependra on 2/20/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import CoreData

class profileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        loadprofilefromcoredata()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadprofilefromcoredata(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        let appDel:AppDelegate = (UIApplication.shared.delegate) as! AppDelegate
        
        let context:NSManagedObjectContext = appDel.managedObjectContext
        
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Profile", in: context)
        fetchRequest.includesPropertyValues = false
        do {
            if let results = try context.fetch(fetchRequest) as? [NSManagedObject] {
                
                print(results.count)
                //TableData.removeAll()
                for result in results {
                    //edict["id"] = result.value(forKey: "id") as? Int16
                    nameLabel.text = result.value(forKey: "full_name") as? String
                    contactLabel.text = result.value(forKey: "contact") as? String
                    addressLabel.text = result.value(forKey: "permanent_address") as? String
                    classLabel.text = result.value(forKey: "name") as? String
                    let imageurl = result.value(forKey: "image") as? String
                   // print(imageurl)
                    profileImage.af_setImage(withURL: URL(string: imageurl!)!)
                    profileImage.layer.cornerRadius = 10
                    profileImage.clipsToBounds = true
                    profileImage.layer.borderWidth = 5
                    profileImage.layer.borderColor = UIColor.white.cgColor            //        TableData.append(datastruct(add: edict as NSDictionary))
                                        

                    //TData[results.count] =
                    //context.delete(result)
                    // print(context.value(forKey: "id"))
                }
                // print(TableData)
                //try context.save()
               // tableView.reloadData()
                
            }
        } catch {
            // LOG.debug("failed to clear core data")
        }
        //print("dataclear")
        
        
    }

    @IBAction func logoutAction(_ sender: Any) {
        if let resultController = storyboard!.instantiateViewController(withIdentifier: "loginPage") as? loginViewController {
            present(resultController, animated: true, completion: nil)
            //loadAllData()
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
