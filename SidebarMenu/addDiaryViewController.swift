//
//  addDiaryViewController.swift
//  nBulletin
//
//  Created by beependra on 4/11/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class addDiaryViewController: UIViewController {

    @IBOutlet weak var noteText: UITextView!
    @IBOutlet weak var titleText: UITextField!
    var newDiary: Dictionary = ["title" : "" , "description" : ""]
    var diary: Array<Any> = []
    var removeAtId:Int? = nil
    var titl = ""
    var note = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
       // UITextField.connectFields(fields: [noteText, titleText])
        
        noteText.layer.borderColor = primaryColor.cgColor
        noteText.layer.borderWidth = 1
        noteText.layer.cornerRadius = 5
        
        titleText.layer.borderColor = primaryColor.cgColor
        titleText.layer.borderWidth = 1
        titleText.layer.cornerRadius = 5
        noteText.text = note
        titleText.text = titl
        // Do any additional setup after loading the view.
    }
   
    func deleteDiary(id: Int){
        print(id)
        
        diary.remove(at: id)
        //diaries = myArray?.reversed()
        datadef.set(diary, forKey: "diaries")
        //myArray = diaries?.reversed()
        
        //tableView.reloadData()
        
    }
    @IBAction func diaryAdd(_ sender: Any) {
        //var diary: Array<Any>
        if datadef.object(forKey: "diaries") != nil {
        
            diary = datadef.object(forKey: "diaries") as! Array<Any>
        
        }
        
        newDiary["title"] = (titleText.text)!
        newDiary["description"] = noteText.text!
        diary.append(newDiary)
        datadef.set(diary, forKey: "diaries")
        print("saved")
        print(diary)
        _ = self.navigationController?.popViewController(animated: true)
        
    }

     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
